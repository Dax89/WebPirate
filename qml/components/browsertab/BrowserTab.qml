import QtQuick 2.1
import Sailfish.Silica 1.0
import "navigationbar"
import "navigationbar/tabbars"
import "dialogs"
import "menus"
import "webview"
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/Database.js" as Database
import "../../js/Favorites.js" as Favorites
import "../../js/Credentials.js" as Credentials

Item
{
    property alias webView: webview
    property alias tabStatus: tabstatus

    function searchRequested()
    {
        navigationbar.queryBar.triggerKeyboard();
    }

    function getIcon()
    {
        if(state === "webbrowser")
            return (webview.icon !== "" ? webview.icon : "image://theme/icon-s-group-chat");

        return "image://theme/icon-m-tabs";
    }

    function getTitle()
    {
        if(navigationbar.queryBar.title.length > 0)
            return navigationbar.queryBar.title

        if(navigationbar.queryBar.url.length > 0)
            return navigationbar.queryBar.url

        return qsTr("New Tab");
    }

    function getUrl()
    {
        if(state === "webbrowser")
            return webview.url.toString();

        return "about:newtab";
    }

    function loadNewTab()
    {
        state = "newtab";
        webview.url = "about:newtab";
    }

    function manageSpecialUrl(url)
    {
        var specialurl = UrlHelper.specialUrl(url);

        if(specialurl === "config")
            pageStack.push(Qt.resolvedUrl("../../pages/SettingsPage.qml"), {"settings": mainwindow.settings });
        else
            loadNewTab();
    }

    function load(req)
    {
        if(!req)
            loadNewTab();

        if(UrlHelper.isSpecialUrl(req))
        {
            manageSpecialUrl(req);
            return;
        }

        state = "webbrowser";

        if(UrlHelper.isUrl(req))
            webview.url = UrlHelper.adjustUrl(req);
        else
            webview.url = mainwindow.settings.searchengines.get(mainwindow.settings.searchengine).query + req;
    }

    function calculateMetrics()
    {
        if(!webview.visible)
            return;

        var keyboardrect = Qt.inputMethod.keyboardRectangle;
        webview.width = mainpage.isPortrait ? Screen.width : Screen.height;
        webview.height = mainpage.isPortrait ? (Screen.height - keyboardrect.height) : (Screen.width - keyboardrect.width);
    }

    Connections { target: Qt.inputMethod; onVisibleChanged: calculateMetrics() }
    Connections { target: mainpage; onOrientationChanged: calculateMetrics() }

    id: browsertab
    visible: false
    Component.onCompleted: calculateMetrics()

    onVisibleChanged: {
        if(!visible) {
            linkmenu.hide();
            return;
        }

        tabview.pageState = browsertab.state; /* Notify TabView's page state */
    }

    onStateChanged: {
        if(visible)
            tabview.pageState = browsertab.state; /* Notify TabView's page state */
    }

    states: [
        State {
            name: "newtab";
            PropertyChanges { target: webview; visible: false }
            PropertyChanges { target: loadingbar; visible: false; canDisplay: false }
            PropertyChanges { target: navigationbar; state: "loaded" }
        },

        State {
            name: "webbrowser";
            PropertyChanges { target: webview; visible: true; }
            PropertyChanges { target: loadingbar; canDisplay: true }
        } ]

    LinkMenu {
        id: linkmenu

        onOpenLinkRequested: browsertab.load(url)
        onOpenTabRequested: tabview.addTab(url, foreground)
        onAddToFavoritesRequested: Favorites.addUrl(url, url)
        onRemoveFromFavoritesRequested: Favorites.removeFromUrl(url)
    }

    CredentialDialog {
        id: credentialdialog
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: tabstatus.top }
    }

    FormResubmitDialog {
        id: formresubmitdialog
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: tabstatus.top }
    }

    BrowserWebView
    {
        id: webview
        visible: false

        onVisibleChanged: {
            if(visible)
                calculateMetrics();
        }
    }

    ViewStack
    {
        id: viewstack
        anchors { left: parent.left; top: parent.top; right: parent.right; bottom: tabstatus.top }

        onEmptyChanged: {
            if(!empty) {
                navigationbar.refreshButton.enabled = false;
                navigationbar.actionButton.enabled = false;
            }
            else if(!UrlHelper.isSpecialUrl(webview.url.toString()))
                navigationbar.actionButton.enabled = true;

            navigationbar.refreshButton.enabled = true;
        }
    }

    Item
    {
        id: tabstatus
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: navigationbar.height + actionbar.height
        z: 10

        onVisibleChanged: {
            if(visible)
                calculateMetrics();
        }

        LoadingBar
        {
            id: loadingbar
            visible: false
            anchors { left: parent.left; bottom: navigationbar.top; right: parent.right }
            minimumValue: 0
            maximumValue: 100
            value: webview.loadProgress
            hideWhenFinished: true
        }

        SearchBar
        {
            id: searchbar
            anchors { bottom: navigationbar.top; left: parent.left; right: parent.right }
        }

        ActionBar
        {
            id: actionbar
            anchors { bottom: navigationbar.top; left: parent.left; right: parent.right }

            onQuickGridRequested: load("about:newtab")
            onHomepageRequested: load(mainwindow.settings.homepage)
            onFindRequested: searchbar.solidify()
        }

        NavigationBar
        {
            id: navigationbar
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            state: webview.loading ? "loading" : "loaded"
            forwardButton.enabled: webview.canGoForward;
            backButton.enabled: !viewstack.empty || webview.canGoBack;

            onActionBarRequested: actionbar.visible ? actionbar.evaporate() : actionbar.solidify()
            onRefreshRequested: webview.reload();
            onStopRequested: webview.stop();
            onSearchRequested: load(searchquery);
            onEvaporated: actionbar.evaporate();

            onBackRequested: {
                searchbar.evaporate();
                actionbar.evaporate();

                if(!viewstack.empty)
                {
                    viewstack.pop();

                    if(!webview.canGoBack)
                        loadNewTab();

                    return;
                }

                webview.goBack();
            }

            onForwardRequested: {
                searchbar.evaporate();
                actionbar.evaporate();
                webview.goForward();
            }

            queryBar.onTextChanged: {
                if(!queryBar.editing) {
                    historymenu.hide();
                    return;
                }

                historymenu.query = text;
            }
        }
    }
}
