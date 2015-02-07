import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "menus"
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites
import "../js/Credentials.js" as Credentials
import "../js/History.js" as History
import "../js/UserAgents.js" as UserAgents
import "../js/YouTubeGrabber.js" as YouTubeGrabber

SilicaWebView
{
    function setNightMode(nightmode)
    {
        if(browsertab.state !== "webbrowser")
            return;

        webview.experimental.evaluateJavaScript("__wp_nightmode__.switchMode(" + nightmode + ")");
    }

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
    experimental.userStyleSheet: mainwindow.settings.adblockmanager.rulesFile

    experimental.userScripts: [ /* SVG Polyfill: From 'canvg' project */
                                Qt.resolvedUrl("../js/canvg/rgbcolor.js"),
                                Qt.resolvedUrl("../js/canvg/StackBlur.js"),
                                Qt.resolvedUrl("../js/canvg/canvg.js"),

                                /* Custom WebView Helpers */
                                Qt.resolvedUrl("../js/helpers/ForcePixelRatio.js"),
                                Qt.resolvedUrl("../js/helpers/WebViewHelper.js"),
                                Qt.resolvedUrl("../js/helpers/YouTubeHelper.js"),
                                Qt.resolvedUrl("../js/helpers/NightMode.js")]

    experimental.onMessageReceived: {
        var data = JSON.parse(message.data);

        if(data.type === "touchstart")
            sidebar.collapse();
        else if(data.type === "newtab")
            tabview.addTab(data.url);
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
        else if(data.type === "youtube_play") {
            pageStack.push(Qt.resolvedUrl("../pages/YouTubeSettingsPage.qml"), {"videoId": data.videoid, "settings": mainwindow.settings });
        }
    }

    experimental.certificateVerificationDialog: RequestMenu {
        title: qsTr("Accept Certificate from:") + " " + webview.url + " ?"
        onRequestAccepted: model.accept()
        onRequestRejected: model.reject()
        onVisibleChanged: visible ? navigationbar.evaporate() : navigationbar.solidify()
        Component.onCompleted: show()
    }

    experimental.itemSelector: ItemSelector {
        selectorModel: model
    }

    experimental.onDownloadRequested: {
        var mime = mimedatabase.mimeFromUrl(downloadItem.url);
        var mimeinfo = mime.split("/");

        if(mimeinfo[0] === "video")
        {
            pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), { "videoSource": downloadItem.url });
            return;
        }

        tabviewremorse.execute(qsTr("Downloading") + " " + downloadItem.suggestedFilename,
                               function() {
                                   mainwindow.settings.downloadmanager.createDownload(downloadItem.url);
                               });
    }

    onLoadingChanged: {
        if(!visible)
            return;

        browsertab.lastError = "";
        navigationbar.state = webview.loading ? "loading" : "loaded";

        if(loadRequest.status === WebView.LoadStartedStatus) {
            navigationbar.solidify();
            tabheader.solidify();
            linkmenu.hide();
            sidebar.collapse();
            historymenu.hide();
        }
        else if(loadRequest.status === WebView.LoadFailedStatus) {
            browsertab.lastError = loadRequest.errorString;
            browsertab.state = "loaderror";
        }
        else if (loadRequest.status === WebView.LoadSucceededStatus)  {
            var stringurl = url.toString();
            navigationbar.favorite = Favorites.contains(stringurl);

            if(!UrlHelper.isSpecialUrl(stringurl) && UrlHelper.isUrl(stringurl))
            {
                webview.experimental.evaluateJavaScript("__webpirate__.polishDocument();
                                                         __yt_webpirate__.convertVideo();");

                Credentials.compile(Database.instance(), mainwindow.settings, stringurl, webview);
                History.store(stringurl, title);
            }

            webview.setNightMode(mainwindow.settings.nightmode);
        }
    }

    onUrlChanged: {
        var stringurl = url.toString();
        navigationbar.searchBar.url = stringurl;

        if(UrlHelper.isSpecialUrl(stringurl))
        {
            manageSpecialUrl(stringurl);
            return;
        }

        browsertab.state = "webbrowser";

        if(!loading && YouTubeGrabber.isYouTubeVideo(stringurl))
            webview.experimental.evaluateJavaScript("__yt_webpirate__.convertVideo()");
    }

    onTitleChanged: navigationbar.searchBar.title = title;

    onVerticalVelocityChanged: {
        if(!visible)
            return;

        if(verticalVelocity < 0)
        {
            navigationbar.solidify();

            if((Math.abs(verticalVelocity) > Screen.height) || (contentY <= 0)) /* Catch Page's begin and QuickScroll: make TabHeader solid, if needed */
                tabheader.solidify();
        }
        else if((verticalVelocity > 0) && (contentY > Theme.itemSizeLarge)) /* Keep Items visibile a little bit */
        {
            navigationbar.evaporate();
            tabheader.evaporate();
        }
    }
}
