import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/settings/Database.js" as Database
import "../../../js/settings/Credentials.js" as Credentials
import "../../../js/settings/PopupBlocker.js" as PopupBlocker
import "../../../js/youtube/YouTubeGrabber.js" as YouTubeGrabber

Item
{
    id: listener

    QtObject
    {
        readonly property var dispatcher: { "console_log": onConsoleLog,
                                            "console_error": onConsoleError,
                                            "touchstart": onTouchStart,
                                            /* "touchmove": onTouchMove, */
                                            "longpress": onLongPress,
                                            "submit": onFormSubmit,
                                            "selector_touch": onSelectorTouched,
                                            "lock_download": lockDownload,
                                            "newtab": newTabRequested,
                                            "window_open": onWindowOpen,
                                            "notification_created": onNotificationCreated,
                                            "play_video": playVideo,
                                            "play_youtube": playYouTubeVideo,
                                            "play_dailymotion": playDailyMotionVideo,
                                            "play_vimeo": playVimeoVideo,
                                            "play_jwplayer": playJwPlayer }

        id: listenerprivate

        function clearEscape(s) {
            return s.replace("&#39;", "'");
        }

        function onConsoleLog(data) {
            console.log(data.log);
        }

        function onConsoleError(data) {
            console.log(data.log);
        }

        function onTouchStart(/* data */) {
            actionbar.evaporate();
            sidebar.collapse();
        }

        /*
        function onTouchMove(data) {
            if(data.moveup) {
                navigationbar.evaporate();
                tabheader.evaporate();
            }
            else if(data.movedown) {
                navigationbar.solidify();
                tabheader.solidify();
            }
        }
        */

        function onLongPress(data) {
            credentialdialog.hide();
            formresubmitdialog.hide();

            if(data.url) {
                linkmenu.title = data.url;
                linkmenu.url = data.url;
                linkmenu.isimage = data.isimage;
                linkmenu.show();
            }
            else if(data.text)
                pageStack.push(Qt.resolvedUrl("../../../pages/TextSelectionPage.qml"), { "text": data.text });
        }

        function onFormSubmit(data) {
            linkmenu.hide();

            if((mainwindow.settings.clearonexit === false) && Credentials.needsDialog(Database.instance(), url.toString(), data)) {
                credentialdialog.url = url.toString();
                credentialdialog.logindata = data;
                credentialdialog.show();
            }
        }

        function onSelectorTouched(data) {
            webview.itemSelectorIndex = data.selectedIndex;
        }

        function lockDownload(data) {
            webview.lockDownload = true;
            webview.lockDownloadAction = data.action;
        }

        function newTabRequested(data) {
            tabview.addTab(data.url);
        }

        function playVideo(data) {
            viewstack.push(Qt.resolvedUrl("../views/browserplayer/BrowserPlayer.qml"), "mediaplayer", { "videoSource": data.url });
        }

        function playYouTubeVideo(data) {
            tabheader.solidify();
            navigationbar.solidify();

            var grabber = viewStack.push(Qt.resolvedUrl("../views/browserplayer/BrowserGrabber.qml"), "mediagrabber");
            YouTubeGrabber.grabVideo(data.videoid, grabber);
        }

        function playDailyMotionVideo(data) {
            tabheader.solidify();
            navigationbar.solidify();

            var grabber = viewStack.push(Qt.resolvedUrl("../views/browserplayer/BrowserGrabber.qml"), "mediagrabber", { "grabFailed": data.videos.length <= 0,
                                                                                                                        "grabStatus": data.videos.length <= 0 ? qsTr("FAILED") : "OK",
                                                                                                                        "videoTitle": clearEscape(data.title),
                                                                                                                        "videoAuthor": clearEscape(data.author),
                                                                                                                        "videoThumbnail": data.thumbnail,
                                                                                                                        "videoDuration": data.duration });

            for(var i = 0; i < data.videos.length; i++)
            {
                var video = data.videos[i];
                grabber.addVideo(qsTr("Codec") + ": " + video.type, mainwindow.settings.mimedatabase.mimeFromUrl(video.url), video.url);
            }
        }

        function playVimeoVideo(data) {
            tabheader.solidify();
            navigationbar.solidify();

            var grabber = viewstack.push(Qt.resolvedUrl("../views/browserplayer/BrowserGrabber.qml"), "mediagrabber", { "grabFailed": data.videos.length <= 0,
                                                                                                                        "grabStatus": data.videos.length <= 0 ? qsTr("FAILED") : "OK",
                                                                                                                        "videoTitle": clearEscape(data.title),
                                                                                                                        "videoAuthor": clearEscape(data.author),
                                                                                                                        "videoThumbnail": data.thumbnail,
                                                                                                                        "videoDuration": data.duration });

            for(var i = 0; i < data.videos.length; i++)
            {
                var video = data.videos[i];
                grabber.addVideo(qsTr("Codec") + ": " + video.type, mainwindow.settings.mimedatabase.mimeFromUrl(video.url), video.url);
            }
        }

        function playJwPlayer(data) {
            viewstack.push(Qt.resolvedUrl("../views/browserplayer/BrowserPlayer.qml"), "mediaplayer", { "videoTitle": data.title, "videoSource": data.url });
        }

        function onWindowOpen(data) {
            var rule = PopupBlocker.getRule(Database.instance(), data.url);

            if(rule === PopupBlocker.NoRule)
                actionbar.blockedPopups.appendPopup(data.url);
            else if(rule === PopupBlocker.AllowRule)
                tabview.addTab(data.url);
            /* else if(rule === PopupBlocker.BlockRule)
                Just Ignore It */
        }

        function onNotificationCreated(data) {
            mainwindow.settings.notifications.send(data.title, data.options.body, (data.options.icon.length ? data.options.icon : "icon-m-notifications"), true, false);
        }
    }

    function execute(message)
    {
        var data = JSON.parse(message.data);
        var eventfn = listenerprivate.dispatcher[data.type];

        if(eventfn)
            eventfn(data);
    }
}
