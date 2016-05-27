import QtQuick 2.1
import Sailfish.Silica 1.0
import "webview"
import "../tabview"
import "../../models"
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/settings/Database.js" as Database
import "../../js/settings/Credentials.js" as Credentials

Item
{
    property alias webView: webview
    property alias viewStack: viewstack

    property bool thumbUpdated: true
    property BlockedPopupModel popups: BlockedPopupModel { }
    property Settings settings
    property TabView tabView
    property var pendingRequests

    readonly property string title: {
        if(webview.title.length > 0)
            return webview.title;

        return qsTr("New Tab");
    }

    readonly property string webUrl: {
        if(state === "newtab")
            return "about:newtab";

        return UrlHelper.printable(webview.url.toString());
    }

    function getSelectedText(callback) {
        if(!pendingRequests)
            pendingRequests = new Object;

        var id = Date.now();
        pendingRequests[id] = callback;
        webview.postMessage("textselectorhandler_gettext", { "id": id, "cancel": true });
    }

    function loadNewTab() {
        state = "newtab";
        webview.url = "about:newtab";
    }

    function manageSpecialUrl(url) {
        var specialurl = UrlHelper.specialUrl(url);

        if(specialurl === "config")
            pageStack.push(Qt.resolvedUrl("../../pages/SettingsPage.qml"), {"settings": mainwindow.settings });
        else
            loadNewTab();
    }

    function load(req) {
        viewstack.clear();

        if(!req)
            loadNewTab();

        if(UrlHelper.isSpecialUrl(req))
        {
            manageSpecialUrl(req);
            return;
        }

        state = "webview";

        if(UrlHelper.protocol(req) === "file")
        {
            webview.url = ""; /* Blank Page */

            var filepath = UrlHelper.filePath(req);

            if(!filepath.length)
                return; /* Empty file:// request, do nothing */

            var mimetype = mainwindow.settings.mimedatabase.mimeFromUrl(filepath);

            if(mimetype === "inode/directory")
            {
                var filepicker = pageStack.push(Qt.resolvedUrl("../../pages/selector/SelectorFilesPage.qml"));

                filepicker.actionCompleted.connect(function(action, data) {
                    webview.url = data;
                });

                return;
            }

            webview.url = filepath;
            return;
        }

        if(UrlHelper.isUrl(req))
            webview.url = UrlHelper.adjustUrl(req);
        else
            webview.url = mainwindow.settings.searchengines.get(mainwindow.settings.searchengine).query + req;
    }

    id: browsertab
    visible: false

    onVisibleChanged: {
        if(!visible)
            return;

        tabview.pageState = browsertab.state; /* Notify TabView's page state */
    }

    onStateChanged: {
        if(!visible)
            return;

        tabview.pageState = browsertab.state; /* Notify TabView's page state */
    }

    BrowserWebView { id: webview; visible: browsertab.state === "webview" }
    ViewStack { id: viewstack; anchors.fill: parent }
}
