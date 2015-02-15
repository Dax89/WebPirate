import QtQuick 2.1
import Sailfish.Silica 1.0
import "navigationbar"
import "dialogs"
import "menus"
import "webview"
import "quickgrid"
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites
import "../js/Credentials.js" as Credentials

Item
{
    property alias webView: webview
    property string lastError: ""

    function searchRequested()
    {
        navigationbar.searchBar.triggerKeyboard();
    }

    id: browsertab
    state: "newtab"

    onVisibleChanged: {
        if(!visible) {
            linkmenu.hide();
            return;
        }

        tabview.pageState = browsertab.state /* Notify TabView's page state */
    }

    onStateChanged: {
        if(visible)
            tabview.pageState = browsertab.state /* Notify TabView's page state */
    }

    states: [
        State {
            name: "newtab";
            PropertyChanges { target: webview; visible: false }
            PropertyChanges { target: loadingbar; visible: false; canDisplay: false }
            PropertyChanges { target: navigationbar; state: "loaded" }
            PropertyChanges { target: loader; active: true; source: Qt.resolvedUrl("quickgrid/QuickGrid.qml"); visible: true; }
        },

        State {
            name: "webbrowser";
            PropertyChanges { target: webview; visible: true; }
            PropertyChanges { target: loadingbar; canDisplay: true }
            PropertyChanges { target: loader; source: ""; visible: false; active: false }
        },

        State {
            name: "loaderror";
            PropertyChanges { target: webview; visible: false; }
            PropertyChanges { target: loadingbar; visible: false; canDisplay: false }
            PropertyChanges { target: navigationbar; state: "loaded" }
            PropertyChanges { target: loader; active: true; source: Qt.resolvedUrl("LoadFailed.qml"); visible: true; }
        } ]

    function getIcon()
    {
        if((state === "newtab") || (state === "loaderror"))
            return "image://theme/icon-m-tabs";

        return (webview.icon !== "" ? webview.icon : "image://theme/icon-s-group-chat");
    }

    function getTitle()
    {
        if(navigationbar.searchBar.title.length > 0)
            return navigationbar.searchBar.title

        if(navigationbar.searchBar.url.length > 0)
            return navigationbar.searchBar.url

        if(navigationbar.state == "loaderror")
            return qsTr("Load Error");

        return qsTr("New Tab");
    }

    function getUrl()
    {
        if(state === "webbrowser")
            return webview.url.toString();

        return "about:newtab";
    }

    function loadDefault()
    {
        state = "newtab";
        webview.url = "about:newtab"
    }

    function manageSpecialUrl(url)
    {
        var specialurl = UrlHelper.specialUrl(url);

        if(specialurl === "config")
            pageStack.push(Qt.resolvedUrl("../pages/SettingsPage.qml"), {"settings": mainwindow.settings });
        else
            loadDefault();
    }

    function load(req) {
        if(UrlHelper.isSpecialUrl(req))
            manageSpecialUrl(req);
        else if(req !== null)
        {
            state = "webbrowser";

            if(UrlHelper.isUrl(req))
                webview.url = UrlHelper.adjustUrl(req);
            else
                webview.url = mainwindow.settings.searchengines.get(mainwindow.settings.searchengine).query + req;
        }
        else
            loadDefault();
    }

    LinkMenu {
        id: linkmenu

        onOpenLinkRequested: browsertab.load(url)
        onOpenTabRequested: tabview.addTab(url)
        onAddToFavoritesRequested: Favorites.addUrl(url, url)
        onRemoveFromFavoritesRequested: Favorites.removeFromUrl(url)
    }

    CredentialDialog {
        id: credentialdialog
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: navigationbar.top }
    }

    HistoryMenu {
        id: historymenu
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: navigationbar.top }
        onUrlRequested: browsertab.load(url)
    }

    Loader
    {
        id: loader
        anchors { left: parent.left; top: parent.top; right: parent.right }
        height: (mainpage.isPortrait ? Screen.height : Screen.width) - navigationbar.height

        onLoaded: {
            tabheader.solidify();
            navigationbar.solidify();

            if(browsertab.state === "loaderror")
            {
                loader.item.offline = webview.experimental.offline;
                loader.item.errorString = browsertab.lastError;
            }
        }
    }

    BrowserWebView
    {
        id: webview
        visible: false
        width: mainpage.isPortrait ? Screen.width : Screen.height
        height: mainpage.isPortrait ? Screen.height : Screen.width
    }

    LoadingBar
    {
        id: loadingbar
        z: 1
        visible: false
        anchors { left: parent.left; bottom: navigationbar.top; right: parent.right }
        minimumValue: 0
        maximumValue: 100
        value: webview.loadProgress
        hideWhenFinished: true
    }

    FindTextBar
    {
        id: findtextbar
        anchors { bottom: navigationbar.top; left: parent.left; right: parent.right }
    }

    ActionBar
    {
        id: actionbar
        anchors { bottom: navigationbar.top; left: parent.left; right: parent.right }

        onHomepageRequested: load(mainwindow.settings.homepage)
        onFindRequested: findtextbar.solidify()
    }

    NavigationBar
    {
        id: navigationbar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        forwardButton.enabled: webview.canGoForward;
        backButton.enabled: webview.canGoBack;

        onActionBarRequested: actionbar.visible ? actionbar.evaporate() : actionbar.solidify()
        onRefreshRequested: webview.reload();
        onStopRequested: webview.stop();
        onSearchRequested: load(searchquery);
        onEvaporated: actionbar.evaporate();

        onBackRequested: {
            findtextbar.evaporate();
            actionbar.evaporate();
            webview.goBack();
        }

        onForwardRequested: {
            findtextbar.evaporate();
            actionbar.evaporate();
            webview.goForward();
        }

        searchBar.onFocusChanged: {
            if(!searchBar.focus)
                historymenu.hide();
        }

        searchBar.onTextChanged: {
            if(webview.loading || !searchBar.editing) {
                historymenu.hide();
                return;
            }

            historymenu.query = text;
        }
    }
}
