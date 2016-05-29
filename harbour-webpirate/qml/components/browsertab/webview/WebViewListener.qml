import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/settings/Database.js" as Database
import "../../../js/settings/Credentials.js" as Credentials
import "../../../js/settings/PopupBlocker.js" as PopupBlocker
import "../../../js/youtube/YouTubeGrabber.js" as YouTubeGrabber

Item
{
    property alias dispatchers: listenerdispatchers

    id: listener

    QtObject
    {
        readonly property var dispatcher: { "touchhandler_longpress": onLongPress,
                                            "touchhandler_select": onSelectorTouched,
                                            "touchhandler_loadurl": loadUrlRequested,
                                            "touchhandler_newtab": newTabRequested,
                                            "submithandler_submit": onFormSubmit,
                                            "stylehandler_style": webPageStyle,
                                            "nightmodehandler_changed": onNightModeChanged,
                                            "textfieldhandler_selected": onTextFieldSelected,
                                            "textselectorhandler_selectedtext": onTextSelectorSelectedText,
                                            "textselectorhandler_displayhandles": onTextSelectorDisplayHandles,
                                            "textselectorhandler_hidehandles": onTextSelectorHideHandles,
                                            "youtubehandler_play": playYouTubeVideo,
                                            "dailymotionhandler_play": playDailyMotionVideo,
                                            "vimeohandler_play": playVimeoVideo,
                                            "tagoverrider_play": playVideo,
                                            "notification_created": onNotificationCreated,
                                            "window_open": onWindowOpen,
                                            "console_error": onConsoleError,
                                            "console_log": onConsoleLog }

        id: listenerdispatchers

        function clearEscape(s) {
            return s.replace(/&#39;/g, "'");
        }

        function escapeString(s) {
            return s.replace(/'/g, "&#39;");
        }

        function onConsoleLog(data) {
            console.log(data.log);
        }

        function onConsoleError(data) {
            console.log(data.log);
        }

        function onLongPress(data) {
            tabView.dialogs.hideAll();
            tabView.dialogs.showLinkMenu(data.url, data.isImage);
        }

        function onSelectorTouched(data) {
            webview.itemSelectorIndex = data.selectedIndex;
        }

        function loadUrlRequested(data) {
            browsertab.load(data.url);
        }

        function newTabRequested(data) {
            tabView.addTab(data.url);
        }

        function onFormSubmit(data) {
            if((mainwindow.settings.clearonexit === false) && Credentials.needsDialog(Database.instance(), url.toString(), data))
                tabView.dialogs.showCredential(url.toString(), data);
        }

        function onTextFieldSelected(data) {
            if(!mainwindow.settings.exp_overridetextfields)
                return;

            var tfpage = pageStack.push(Qt.resolvedUrl("../../../pages/webview/TextFieldPage.qml"), { "elementId": data.id, "maxLength": data.maxLength,
                                                                                                      "selectionStart": data.selectionStart, "selectionEnd": data.selectionEnd,
                                                                                                      "text": clearEscape(data.text) });

            tfpage.accepted.connect(function() {
                var data = { "id": tfpage.elementId, "text": escapeString(tfpage.text) };

                if(tfpage.selectionStart !== tfpage.selectionEnd) {
                    data.selectionStart = tfpage.selectionStart;
                    data.selectionEnd = tfpage.selectionEnd;
                }

                webview.postMessage("textfieldhandler_sendedit", data);
                Qt.inputMethod.hide();
            });

            tfpage.rejected.connect(function() {
                webview.postMessage("textfieldhandler_canceledit", { "id": tfpage.elementId });
                Qt.inputMethod.hide();
            });
        }

        function onTextSelectorSelectedText(data) {
            if(!browsertab.pendingRequests[data.id])
                return;

            var callback = browsertab.pendingRequests[data.id];
            callback(clearEscape(data.text));

            delete browsertab.pendingRequests[data.id];
        }

        function onTextSelectorDisplayHandles(data) {
            selector.select(data);
        }

        function onTextSelectorHideHandles() {
            selector.hide();
        }

        function webPageStyle(data) {
            if(!data.backgroundcolor) {
                vscrolldecorator.color = Theme.primaryColor;
                return;
            }

            var color = data.backgroundcolor;
            vscrolldecorator.color = "#" + ((1 << 24) + ((255 - color.r) << 16) + ((255 - color.g) << 8) + (255 - color.b)).toString(16).slice(1);
        }

        function playVideo(data) {
            viewstack.push(Qt.resolvedUrl("../views/browserplayer/BrowserPlayer.qml"), "mediaplayer", { "videoSource": data.url });
        }

        function playYouTubeVideo(data) {
            var grabber = viewStack.push(Qt.resolvedUrl("../views/browsergrabber/BrowserGrabber.qml"), "mediagrabber");
            YouTubeGrabber.grabVideo(data.videoId, grabber);
        }

        function playDailyMotionVideo(data) {
            var grabber = viewStack.push(Qt.resolvedUrl("../views/browsergrabber/BrowserGrabber.qml"), "mediagrabber", { "grabFailed": data.videos.length <= 0,
                                                                                                                         "grabStatus": data.videos.length <= 0 ? qsTr("No videos found, report to developer") : qsTr("Video grabbed successfully"),
                                                                                                                         "videoTitle": clearEscape(data.title),
                                                                                                                         "videoAuthor": clearEscape(data.author),
                                                                                                                         "videoThumbnail": data.thumbnail,
                                                                                                                         "videoDuration": data.duration });

            for(var i = 0; i < data.videos.length; i++) {
                var video = data.videos[i];
                grabber.addVideo(qsTr("Codec") + ": " + video.type, mainwindow.settings.mimedatabase.mimeFromUrl(video.url), video.url);
            }
        }

        function playVimeoVideo(data) {
            var grabber = viewstack.push(Qt.resolvedUrl("../views/browsergrabber/BrowserGrabber.qml"), "mediagrabber", { "grabFailed": data.videos.length <= 0,
                                                                                                                         "grabStatus": data.videos.length <= 0 ? qsTr("No videos found, report to developer") : qsTr("Video grabbed successfully"),
                                                                                                                         "videoTitle": clearEscape(data.title),
                                                                                                                         "videoAuthor": clearEscape(data.author),
                                                                                                                         "videoThumbnail": data.thumbnail,
                                                                                                                         "videoDuration": data.duration });

            for(var i = 0; i < data.videos.length; i++) {
                var video = data.videos[i];
                grabber.addVideo(qsTr("Codec") + ": " + video.type, mainwindow.settings.mimedatabase.mimeFromUrl(video.url), video.url);
            }
        }

        function onWindowOpen(data) {
            var rule = PopupBlocker.getRule(Database.instance(), data.url);

            if(rule === PopupBlocker.NoRule)
                browsertab.popups.appendPopup(data.url);
            else if(rule === PopupBlocker.AllowRule)
                tabView.addTab(data.url);
            /* else if(rule === PopupBlocker.BlockRule)
                Just Ignore It */
        }

        function onNotificationCreated(data) {
            mainwindow.settings.notifications.send(data.title, data.options.body, true, false);
        }

        function onNightModeChanged(data) {
            webview.nightModeEnabled = data.enabled;
        }
    }

    function execute(message)
    {
        var dataobj = JSON.parse(message.data);
        var eventfn = listenerdispatchers.dispatcher[dataobj.type];

        if(eventfn)
            eventfn(dataobj.data);
    }
}
