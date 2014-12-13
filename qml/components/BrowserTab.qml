import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites

Item
{
    id: browsertab
    state: "favorites"

    signal settingsRequested()

    states: [
        State {
            name: "favorites";
            PropertyChanges { target: webview; visible: false }
            PropertyChanges { target: favoritesview; visible: true }
            PropertyChanges { target: loadfailed; visible: false }
        },

        State {
            name: "webbrowser";
            PropertyChanges { target: webview; visible: true }
            PropertyChanges { target: favoritesview; visible: false }
            PropertyChanges { target: loadfailed; visible: false }
        },

        State {
            name: "loaderror";
            PropertyChanges { target: webview; visible: false }
            PropertyChanges { target: favoritesview; visible: false }
            PropertyChanges { target: loadfailed; visible: true }
        } ]

    function getIcon()
    {
        if(state == "favorites")
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
            return "Load Error";

        return qsTr("New Tab");
    }

    function loadDefault()
    {
        state = "favorites";
        webview.url = "about:bookmarks";
        navigationbar.searchBar.url = "about:bookmarks";
    }

    function manageSpecialUrl(url)
    {
        var specialurl = UrlHelper.specialUrl(url);

        if(specialurl === "config")
            settingsRequested();

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

    LinkPanel
    {
        id: linkpanel
        anchors.fill: parent
        visible: false;
        z: 2

        onOpenLinkRequested: browsertab.load(url)
        onOpenTabRequested: tabview.addTab(url)
        onAddToFavoritesRequested: Favorites.add(Database.instance(), mainwindow.settings.favorites, url, url)
        onRemoveFromFavoritesRequested: Favorites.remove(Database.instance(), mainwindow.settings.favorites, url)
    }

    Column
    {
        anchors.fill: parent

        FavoritesView
        {
            id: favoritesview
            width: parent.width
            height: parent.height - navigationbar.height

            onUrlRequested: load(favoriteurl);
        }

        LoadFailed
        {
            id: loadfailed
            width: parent.width
            height: parent.height - navigationbar.height
        }

        SilicaWebView
        {
            id: webview
            width: parent.width
            height: parent.height - navigationbar.height
            quickScroll: false

            /* Experimental WebView Features */
            experimental.preferences.webGLEnabled: true
            experimental.preferences.pluginsEnabled: true
            experimental.preferences.navigatorQtObjectEnabled: true
            experimental.preferences.developerExtrasEnabled: true
            experimental.userScripts: [Qt.resolvedUrl("../js/WebViewHelper.js")]
            experimental.userAgent: mainwindow.settings.useragents.get(mainwindow.settings.useragent).value
            experimental.deviceWidth: width
            experimental.deviceHeight: height

            experimental.onMessageReceived: {
                var data = JSON.parse(message.data);

                if(data.type === "longpress")
                {
                    linkpanel.url = data.url;
                    linkpanel.visible = true;
                }
            }

            experimental.certificateVerificationDialog: Item {
                Component.onCompleted: {
                    var dlg = pageStack.push(Qt.resolvedUrl("ConfirmDialog.qml"), {"message": qsTr("Accept Certificate from: ") + webview.url + " ?" });

                    dlg.accepted.connect(function() {
                        model.accept();
                    });

                    dlg.rejected.connect(function() {
                        model.reject();
                    });
                }
            }

            header: LoadingBar {
                id: loadingbar
                minimumValue: 0
                maximumValue: 100
                width: webview.width
                value: webview.loadProgress
                height: 4
            }

            onLoadingChanged: {
                if(loadRequest.status === WebView.LoadStartedStatus) {
                    navigationbar.state = "loading";
                }
                else if(loadRequest.status === WebView.LoadFailedStatus) {
                    loadfailed.offline = experimental.offline;
                    loadfailed.errorString = loadRequest.errorString;
                    browsertab.state = "loaderror";
                    navigationbar.state = "loaded";
                }
                else if (loadRequest.status === WebView.LoadSucceededStatus)  {
                    var idx = mainwindow.settings.favorites.indexOf(url.toString())
                    navigationbar.state = "loaded";
                    navigationbar.favorite = (idx !== -1);

                    /* FIXME: Check Favicon
                    if(navigationbar.favorite)
                    {
                        var favorite = mainwindow.settings.favorites.get(idx);
                        mainwindow.settings.favorites.fetchIcon(url.toString(), favorite);
                        Favorites.setIcon(Database.instance(), mainwindow.settings.favorites, url.toString(), favorite.icon);
                    }
                    */
                }
            }

            onUrlChanged: {
                if(UrlHelper.isSpecialUrl(url.toString()))
                    manageSpecialUrl(url.toString());
                else
                    browsertab.state = "webbrowser";

                navigationbar.searchBar.url = url;
            }

            onTitleChanged: {
                navigationbar.searchBar.title = title;
            }
        }

        NavigationBar
        {
            id: navigationbar
            z: 1
            width: parent.width
            forwardButton.enabled: webview.canGoForward;
            backButton.enabled: webview.canGoBack;

            onForwardRequested: webview.goForward();
            onBackRequested: webview.goBack();
            onRefreshRequested: webview.reload();
            onStopRequested: webview.stop();
            onSearchRequested: load(searchquery);
        }
    }

    onVisibleChanged: {
        if(!visible)
            linkpanel.visible = false;
    }
}
