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

        experimental.postMessage(nightmode ? "enable_nightmode" : "disable_nightmode");
    }

    VerticalScrollDecorator { flickable: webview }
    WebViewListener { id: listener }

    Rectangle /* Night Mode Rectangle */
    {
        x: contentX
        y: webview.contentHeight - 1
        width: Math.max(webview.contentWidth, webview.width)
        height: Math.max(webview.contentHeight, webview.height)
        color: mainwindow.settings.nightmode ? "black" : "white"
    }

    id: webview

    /* Experimental WebView Features */
    experimental.preferences.webGLEnabled: true
    experimental.preferences.dnsPrefetchEnabled: true
    experimental.preferences.pluginsEnabled: true
    experimental.preferences.javascriptEnabled: true
    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.preferences.developerExtrasEnabled: true
    experimental.transparentBackground: true
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
                                Qt.resolvedUrl("../../js/helpers/NightMode.js"),
                                Qt.resolvedUrl("../../js/helpers/MessageListener.js"), ]

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
    experimental.itemSelector: ItemSelector { selectorModel: model }
    experimental.onMessageReceived: listener.execute(message)

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

    onNavigationRequested: {
        var stringurl = request.url.toString();
        browsertab.lastError = "";

        if(UrlHelper.isSpecialUrl(stringurl) || (request.navigationType === WebView.FormSubmittedNavigation))
            return;

        if(request.navigationType === WebView.FormResubmittedNavigation)
        {
            request.action = WebView.IgnoreRequest;
            formresubmitdialog.url = stringurl;
            formresubmitdialog.show();
            return;
        }

        if((request.navigationType === WebView.OtherNavigation) && UrlHelper.domainName(url.toString()) !== UrlHelper.domainName(stringurl))
            return; /* Ignore Other Domain Requests */

        experimental.postMessage("forcepixelratio");
        webview.setNightMode(mainwindow.settings.nightmode);

        if(YouTubeGrabber.isYouTubeVideo(stringurl))
            experimental.postMessage("youtube_convertvideo");
    }

    onLoadingChanged: {
        if(!visible)
            return;

        if(loadRequest.status === WebView.LoadStartedStatus)
        {
            actionbar.blockedPopups.clear();
            actionbar.evaporate();
            findtextbar.evaporate();
            navigationbar.solidify();
            tabheader.solidify();
            linkmenu.hide();
            sidebar.collapse();
            historymenu.hide();
            return;
        }

        if(loadRequest.status === WebView.LoadFailedStatus)
        {
            browsertab.lastError = loadRequest.errorString;
            browsertab.state = "loaderror";
            return;
        }

        if(loadRequest.status === WebView.LoadSucceededStatus)
        {
            var stringurl = url.toString();
            actionbar.favorite = Favorites.contains(stringurl);

            if(!UrlHelper.isSpecialUrl(stringurl) && UrlHelper.isUrl(stringurl))
            {
                experimental.postMessage("polish_document");
                experimental.postMessage("youtube_convertvideo");

                Credentials.compile(Database.instance(), mainwindow.settings, stringurl, webview);
                History.store(stringurl, title);
            }
        }
    }

    onUrlChanged: {
        var stringurl = url.toString();
        navigationbar.searchBar.url = stringurl;

        if(UrlHelper.isSpecialUrl(stringurl))
        {
            navigationbar.actionButton.enabled = false;
            manageSpecialUrl(stringurl);
            return;
        }

        navigationbar.actionButton.enabled = true;
        browsertab.state = "webbrowser";
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
        else if(verticalVelocity > 0)
        {
            navigationbar.evaporate();
            tabheader.evaporate();
        }
    }
}
