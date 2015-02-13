import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../menus"
import "jsdialogs"
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/Database.js" as Database
import "../../js/Favorites.js" as Favorites
import "../../js/Credentials.js" as Credentials
import "../../js/History.js" as History
import "../../js/UserAgents.js" as UserAgents
import "../../js/YouTubeGrabber.js" as YouTubeGrabber

SilicaWebView
{
    property int itemSelectorIndex: -1 /* Keeps the selected index of ItemSelector */

    function setNightMode(nightmode)
    {
        if(browsertab.state !== "webbrowser")
            return;

        webview.experimental.evaluateJavaScript("__wp_nightmode__.switchMode(" + nightmode + ")");
    }

    id: webview

    VerticalScrollDecorator { flickable: webview }
    WebViewListener { id: listener }

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
                                Qt.resolvedUrl("../../js/canvg/rgbcolor.js"),
                                Qt.resolvedUrl("../../js/canvg/StackBlur.js"),
                                Qt.resolvedUrl("../../js/canvg/canvg.js"),

                                /* Custom WebView Helpers */
                                Qt.resolvedUrl("../../js/helpers/ForcePixelRatio.js"),
                                Qt.resolvedUrl("../../js/helpers/WebViewHelper.js"),
                                Qt.resolvedUrl("../../js/helpers/YouTubeHelper.js"),
                                Qt.resolvedUrl("../../js/helpers/NightMode.js")]

    experimental.onTextFound: {
        findtextbar.findError = (matchCount <= 0);
    }

    experimental.certificateVerificationDialog: RequestDialog {
        title: qsTr("Accept Certificate from:") + " " + webview.url + " ?"
        onRequestAccepted: model.accept()
        onRequestRejected: model.reject()
    }

    experimental.alertDialog: AlertDialog {
        title: model.message
        onOkPressed: model.dismiss()
        onIgnoreDialog: model.dismiss()
    }

    experimental.confirmDialog: RequestDialog {
        title: message
        onRequestAccepted: model.accept()
        onRequestRejected: model.reject()
        onIgnoreDialog: model.reject()
    }

    experimental.promptDialog: Item { /* PromptDialog is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            pageStack.push(Qt.resolvedUrl("jsdialogs/PromptDialog.qml"), { "promptModel": model, "title": message, "textField": defaultValue });
        }
    }

    experimental.authenticationDialog: Item { /* AuthenticationDialog is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            pageStack.push(Qt.resolvedUrl("jsdialogs/AuthenticationDialog.qml"), { "authenticationModel": model })
        }
    }

    experimental.colorChooser: Item {  /* ColorChooser is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            pageStack.push(Qt.resolvedUrl("jsdialogs/ColorChooserDialog.qml"), { "colorModel": model, "color": model.currentColor });
        }
    }

    experimental.filePicker: FilePickerDialog { }
    experimental.onMessageReceived: listener.execute(message)
    experimental.itemSelector: ItemSelector { selectorModel: model }

    experimental.onDownloadRequested: {
        var mime = mimedatabase.mimeFromUrl(downloadItem.url);
        var mimeinfo = mime.split("/");

        if(mimeinfo[0] === "video")
        {
            pageStack.push(Qt.resolvedUrl("../../pages/VideoPlayerPage.qml"), { "videoSource": downloadItem.url });
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
            actionbar.evaporate();
            findtextbar.evaporate();
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
            actionbar.favorite = Favorites.contains(stringurl);

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
