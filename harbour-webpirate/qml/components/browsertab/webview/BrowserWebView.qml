import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import "../../../js/UrlHelper.js" as UrlHelper
import "../../../js/settings/Database.js" as Database
import "../../../js/settings/Credentials.js" as Credentials
import "../../../js/settings/History.js" as History
import "../../../js/settings/UserAgents.js" as UserAgents
import "../../../js/settings/Favorites.js" as Favorites

SilicaWebView
{
    property int itemSelectorIndex: -1    /* Keeps the selected index of ItemSelector    */
    property bool nightModeEnabled: false /* Check if Night Mode is visually active      */
    property bool favorite: false

    function setNightMode(nightmode) {
        if(browsertab.state !== "webview")
            return;

        experimental.postMessage(nightmode ? "nightmode_enable" : "nightmode_disable");
    }

    function calculateMetrics(ignorewidth, ignoreheight) {
        if(!webview.visible)
            return;

        if(!ignorewidth)
            webview.width = tabView.width;

        if(!ignoreheight)
            webview.height = tabView.height;

        browsertab.thumbUpdated = !ignorewidth || !ignoreheight;
    }

    UrlSchemeDelegateHandler { id: urlschemedelegatehandler }
    WebViewListener { id: listener }
    VerticalScrollDecorator { id: vscrolldecorator; flickable: webview }

    Connections
    {
        target: tabView

        onWidthChanged: calculateMetrics(false, true)
        onHeightChanged: calculateMetrics(true, false)
    }

    PullDownMenu
    {
        id: pulldownmenu
        enabled: webview.visible

        onActiveChanged: {
            if(!active)
                return;

            tabView.navigationBar.solidify();
        }

        MenuItem
        {
            text: webview.favorite ? qsTr("Remove from Favorites") : qsTr("Add to Favorites")
            visible: !webview.loading

            onClicked: {
                if(webview.favorite) {
                    Favorites.removeFromUrl(browsertab.webUrl);
                    webview.favorite = false;
                    return;
                }

                Favorites.addUrl(browsertab.title, browsertab.webUrl, 0);
                webview.favorite = true;
            }
        }

        MenuItem
        {
            text: webview.loading ? qsTr("Stop") : qsTr("Refresh")
            onClicked: webview.loading ? webview.stop() : webview.reload()
        }

        MenuItem
        {
            text: qsTr("New tab")
            onClicked: tabView.addTab(mainwindow.settings.homepage)
        }
    }

    Rectangle /* Night Mode Rectangle */
    {
        x: contentX
        y: (mainwindow.settings.nightmode && !webview.nightModeEnabled) ? contentY : (webview.contentHeight - 1)

        width:{
            if(mainwindow.settings.nightmode && !webview.nightModeEnabled)
                return webview.width;

            return Math.max(webview.contentWidth, webview._page.width);
        }

        height:{
            if(mainwindow.settings.nightmode && !webview.nightModeEnabled)
                return webview.height;

            return Math.max(webview.contentHeight, webview._page.height);
        }

        color: "#181818" /* Do not use 100% black */
        visible: mainwindow.settings.nightmode
    }

    id: webview
    overridePageStackNavigation: true
    onVisibleChanged: calculateMetrics(false, false)

    /* Experimental WebView Features */
    experimental.preferences.webGLEnabled: true
    experimental.preferences.notificationsEnabled: true
    experimental.preferences.dnsPrefetchEnabled: true
    experimental.preferences.javascriptEnabled: true
    experimental.preferences.localStorageEnabled: true
    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.preferredMinimumContentsWidth: 980 /* "magic" number that proved to work great on the majority of websites */
    experimental.userAgent: UserAgents.get(mainwindow.settings.useragent).value
    experimental.userStyleSheet: mainwindow.settings.adblockmanager.rulesFile

    experimental.userScripts: [ // Forward 'console' object to Qt's one
                                Qt.resolvedUrl("../../../js/helpers/Console.js"),

                                // WebView Utils Functions
                                Qt.resolvedUrl("../../../js/helpers/Utils.js"),

                                // Overrides
                                Qt.resolvedUrl("../../../js/helpers/overrides/AjaxOverrider.js"),
                                Qt.resolvedUrl("../../../js/helpers/overrides/TagOverrider.js"),

                                /* Polyfills */
                                Qt.resolvedUrl("../../../js/polyfills/es6-collections.min.js"), // ES6 Harmony Collections: https://github.com/WebReflection/es6-collections
                                Qt.resolvedUrl("../../../js/polyfills/canvg.min.js"),           // SVG Support: https://github.com/gabelerner/canvg

                                // Custom WebView Helpers
                                Qt.resolvedUrl("../../../js/helpers/ForcePixelRatio.js"),
                                Qt.resolvedUrl("../../../js/helpers/WebViewHelper.js"),
                                Qt.resolvedUrl("../../../js/helpers/SystemTextField.js"),
                                Qt.resolvedUrl("../../../js/helpers/NightMode.js"),
                                Qt.resolvedUrl("../../../js/helpers/GrabberBuilder.js"),

                                // Video Helpers
                                Qt.resolvedUrl("../../../js/helpers/video/YouTubeHelper.js"),
                                Qt.resolvedUrl("../../../js/helpers/video/DailyMotionHelper.js"),
                                Qt.resolvedUrl("../../../js/helpers/video/VimeoHelper.js"),
                                Qt.resolvedUrl("../../../js/helpers/video/VideoHelper.js"),

                                // Message Listener
                                Qt.resolvedUrl("../../../js/helpers/MessageListener.js"),

                                // Complete Web Notifications Implementation
                                Qt.resolvedUrl("../../../js/helpers/Notification.js"),

                                // TOHKBD Support (WebView side)
                                Qt.resolvedUrl("../../../js/helpers/TOHKBD.js") ]

    experimental.onTextFound: {
        tabView.navigationBar.queryBar.findError = (matchCount <= 0);
    }

    experimental.certificateVerificationDialog: Item {
        Component.onCompleted: {
            tabView.dialogs.showRequest(model, qsTr("Accept Certificate from: %1 ?").arg(webview.url));
        }
    }

    experimental.alertDialog: Item {
        Component.onCompleted: {
            tabView.dialogs.showAlert(model);
        }
    }

    experimental.confirmDialog: Item {
        Component.onCompleted: {
            tabView.dialogs.showRequest(model, message);
        }
    }

    experimental.filePicker: Item { /* FilePicker is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            var page = pageStack.push(Qt.resolvedUrl("../../../pages/selector/SelectorFilesPage.qml"));

            page.actionCompleted.connect(function(action, data) {
                model.accept(data.toString().substring(7)); // Strip "file://"
            });

            page.rejected.connect(function() {
                model.reject();
            });
        }
    }

    experimental.promptDialog: Item { /* PromptDialog is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            pageStack.push(Qt.resolvedUrl("../../../pages/webview/dialogs/PromptDialog.qml"), { "promptModel": model, "title": message, "textField": defaultValue });
        }
    }

    experimental.authenticationDialog: Item { /* AuthenticationDialog is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            pageStack.push(Qt.resolvedUrl("../../../pages/webview/dialogs/AuthenticationDialog.qml"), { "authenticationModel": model })
        }
    }

    experimental.colorChooser: Item {  /* ColorChooser is particular: A dedicated page suits better */
        Component.onCompleted: {
            if(pageStack.busy)
                pageStack.completeAnimation();

            pageStack.push(Qt.resolvedUrl("../../../pages/webview/dialogs/ColorChooserDialog.qml"), { "colorModel": model, "color": model.currentColor });
        }
    }

    experimental.itemSelector: Item {
        Component.onCompleted: {
            tabView.dialogs.showItemSelector(model, browsertab);
        }
    }

    experimental.onMessageReceived: listener.execute(message)
    experimental.onPermissionRequested: tabView.dialogs.showNotification(webview.url.toString(), browsertab)
    experimental.onProcessDidCrash: viewstack.push(Qt.resolvedUrl("../views/LoadFailed.qml"), "loaderror", { "errorString": webview.url, "offline": experimental.offline, "crash": true });

    experimental.onDownloadRequested: {
        var mime = mainwindow.settings.mimedatabase.mimeFromUrl(downloadItem.url);
        var mimeinfo = mime.split("/");

        if((mimeinfo[0] === "video") || (mimeinfo[0] === "audio")) {
            viewstack.push(Qt.resolvedUrl("../views/browserplayer/BrowserPlayer.qml"), "mediaplayer", { "videoTitle": downloadItem.suggestedFilename, "videoSource": downloadItem.url });
            return;
        }

        tabviewremorse.execute(qsTr("Downloading") + " " + downloadItem.suggestedFilename,
                               function() {
                                   mainwindow.settings.downloadmanager.createDownload(downloadItem);
                               });
    }

    onUrlChanged: {
        var stringurl = url.toString();

        if(UrlHelper.isSpecialUrl(stringurl)) {
            manageSpecialUrl(stringurl);
            return;
        }

        browsertab.state = "webview";

        if(!loading)
            experimental.postMessage("video_get");
    }

    onVerticalVelocityChanged: {
        if(!visible || pulldownmenu.active)
            return;

        if(verticalVelocity < 0)
            tabView.navigationBar.solidify();
        else if(verticalVelocity > 0)
            tabView.navigationBar.evaporate();
    }

    onNavigationRequested: {
        var stringurl = request.url.toString();
        var protocol = UrlHelper.protocol(stringurl);

        if(urlschemedelegatehandler.handleProtocol(protocol, request.url)) {
            request.action = WebView.IgnoreRequest;
            return;
        }

        if(((protocol !== "http") && (protocol !== "https")) || UrlHelper.isSpecialUrl(stringurl) || (request.navigationType === WebView.FormSubmittedNavigation))
            return;

        if(request.navigationType === WebView.FormResubmittedNavigation) {
            request.action = WebView.IgnoreRequest;
            tabView.dialogs.showFormResubmit(stringurl, browsertab);
            return;
        }

        if((request.navigationType === WebView.OtherNavigation) && UrlHelper.domainName(url.toString()) !== UrlHelper.domainName(stringurl))
            return; /* Ignore Other Domain Requests */
    }

    onLoadingChanged: {
        if(loadRequest.status === WebView.LoadStartedStatus) {
            if(browsertab.state === "loaderror") {
                viewstack.pop(); // Pop out error page
                browsertab.state == "webview";
            }

            if(visible) {
                tabView.dialogs.hideAll();
                tabView.navigationBar.solidify();
                Qt.inputMethod.hide();
            }

            browsertab.popups.clear();
            webview.nightModeEnabled = false;
            return;
        }

        if(loadRequest.status === WebView.LoadFailedStatus) {
            browsertab.thumbUpdated = true;
            viewstack.push(Qt.resolvedUrl("../views/LoadFailed.qml"), "loaderror", { "errorString": loadRequest.errorString, "offline": experimental.offline, "crash": false });
            return;
        }

        if(loadRequest.status === WebView.LoadSucceededStatus) {
            var stringurl = url.toString();
            webview.favorite = Favorites.contains(stringurl);

            if(!UrlHelper.isSpecialUrl(stringurl) && UrlHelper.isUrl(stringurl)) {

                if(settings.adblockmanager.enabled)
                    experimental.postMessage(JSON.stringify({ type: "apply_blacklist", blacklist: settings.adblockmanager.hostsBlackList }));

                experimental.postMessage("polish_view");
                experimental.postMessage("video_get");
                experimental.postMessage("textfield_override");

                webview.setNightMode(mainwindow.settings.nightmode);

                Credentials.compile(Database.instance(), stringurl, webview);
                History.store(stringurl, title);
            }

            browsertab.thumbUpdated = true;
        }
    }
}
