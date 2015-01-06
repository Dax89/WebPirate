import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "menus"
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites
import "../js/Credentials.js" as Credentials
import "../js/History.js" as History
import "../js/UserAgents.js" as UserAgents

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
    experimental.userAgent: UserAgents.get(mainwindow.settings.useragent).value
    experimental.userScripts: [ Qt.resolvedUrl("../js/WebViewHelper.js") ]

    experimental.onMessageReceived: {
        var data = JSON.parse(message.data);

        if(data.type === "touchstart")
            sidebar.collapse();
        else if(data.type === "longpress") {
            credentialmenu.hide();

            if(data.url) {
                linkmenu.url = data.url;
                linkmenu.isimage = data.isimage;
                linkmenu.show();
            }
            else if(data.text)
                pageStack.push(Qt.resolvedUrl("../pages/TextSelectionPage.qml"), { "text": data.text });
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

    onLoadingChanged: {
        if(loadRequest.status === WebView.LoadStartedStatus) {
            navigationbar.expand();
            linkmenu.hide();
            sidebar.collapse();
            historymenu.hide();
        }
        else if(loadRequest.status === WebView.LoadFailedStatus) {
            loadfailed.offline = experimental.offline;
            loadfailed.errorString = loadRequest.errorString;
            browsertab.state = "loaderror";
        }
        else if (loadRequest.status === WebView.LoadSucceededStatus)  {
            navigationbar.favorite = Favorites.contains(url.toString());

            if(!UrlHelper.isSpecialUrl(url.toString()) && UrlHelper.isUrl(url.toString()))
            {
                Credentials.compile(Database.instance(), mainwindow.settings, url.toString(), webview);
                History.store(url.toString(), title);
            }
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

    onVerticalVelocityChanged: {
        if(verticalVelocity < 0)
            navigationbar.expand();
        else if(verticalVelocity > 0)
            navigationbar.collapse();
    }
}
