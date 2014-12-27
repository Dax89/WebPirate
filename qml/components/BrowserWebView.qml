import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "menus"
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites
import "../js/Credentials.js" as Credentials
import "../js/History.js" as History

SilicaWebView
{
    id: webview

    VerticalScrollDecorator { flickable: webview }

    /* Experimental WebView Features */
    experimental.preferences.webGLEnabled: true
    experimental.preferences.dnsPrefetchEnabled: true
    experimental.preferences.pluginsEnabled: true
    experimental.preferences.javascriptEnabled: true
    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.preferences.developerExtrasEnabled: true
    experimental.userScripts: [Qt.resolvedUrl("../js/WebViewHelper.js")]
    experimental.userAgent: mainwindow.settings.useragents.get(mainwindow.settings.useragent).value

    experimental.onMessageReceived: {
        var data = JSON.parse(message.data);

        if(data.type === "touchmove") {
            if(data.moveup)
                navigationbar.collapse();
            else if(data.movedown)
                navigationbar.expand();
        }
        else if(data.type === "selectionchanged") {
            selector.show(data.left, data.top, data.right, data.bottom);
        }
        else if(data.type === "longpress") {
            credentialmenu.hide();

            if(data.url) {
                linkmenu.url = data.url;
                linkmenu.show();
            }
            else if(data.text) {
                pageStack.push(Qt.resolvedUrl("../pages/TextSelectionPage.qml"), { "text": data.text });
            }
        }
        else if(data.type === "submit") {
            linkmenu.hide();

            if((mainwindow.settings.clearonexit === false) && Credentials.needsDialog(Database.instance(), mainwindow.settings, url.toString(), data))
            {
                credentialmenu.url = url.toString();
                credentialmenu.logindata = data;
                credentialmenu.show();
            }
        }
    }

    experimental.certificateVerificationDialog: RequestMenu {
        title: qsTr("Accept Certificate from:") + " " + webview.url + " ?"
        onRequestAccepted: model.accept()
        onRequestRejected: model.reject()
        onVisibleChanged: visible ? navigationbar.collapse() : navigationbar.expand()
        Component.onCompleted: show()
    }

    experimental.itemSelector: ItemSelector {
        selectorModel: model
    }

    experimental.onDownloadRequested: {
        tabviewremorse.execute(qsTr("Downloading") + " " + downloadItem.suggestedFilename,
                               function() {
                                   mainwindow.settings.downloadmanager.createDownload(downloadItem.url);
                               });
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
        historymenu.hide();

        if(loadRequest.status === WebView.LoadStartedStatus) {
            navigationbar.state = "loading";
            navigationbar.expand();
            linkmenu.hide();
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

            if(!UrlHelper.isSpecialUrl(url.toString()) && UrlHelper.isUrl(url.toString()))
            {
                Credentials.compile(Database.instance(), mainwindow.settings, url.toString(), webview);
                History.store(Database.instance(), url.toString(), title);
            }

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

    onTitleChanged: navigationbar.searchBar.title = title;
}
