import QtQuick 2.1
import "../../js/Database.js" as Database
import "../../js/Credentials.js" as Credentials

Item
{
    id: listener

    QtObject
    {
        readonly property var dispatcher: { "touchstart": onTouchStart,
                                            "longpress": onLongPress,
                                            "submit": onFormSubmit,
                                            "selector_touch": onSelectorTouched,
                                            "newtab": newTabRequested,
                                            "youtube_play": playVideo,
                                            "window_open": onWindowOpen }

        id: listenerprivate

        function onTouchStart(/* data */) {
            actionbar.evaporate();
            sidebar.collapse();
        }

        function onLongPress(data) {
            credentialdialog.hide();

            if(data.url) {
                linkmenu.url = data.url;
                linkmenu.isimage = data.isimage;
                linkmenu.show();
            }
            else if(data.text)
                pageStack.push(Qt.resolvedUrl("../../pages/TextSelectionPage.qml"), { "text": data.text });
        }

        function onFormSubmit(data) {
            linkmenu.hide();

            if((mainwindow.settings.clearonexit === false) && Credentials.needsDialog(Database.instance(), mainwindow.settings, url.toString(), data)) {
                credentialdialog.url = url.toString();
                credentialdialog.logindata = data;
                credentialdialog.show();
            }
        }

        function onSelectorTouched(data) {
            webview.itemSelectorIndex = data.selectedIndex;
        }

        function newTabRequested(data) {
            tabview.addTab(data.url);
        }

        function playVideo(data) {
            pageStack.push(Qt.resolvedUrl("../../pages/YouTubeSettingsPage.qml"), {"videoId": data.videoid, "settings": mainwindow.settings });
        }

        function onWindowOpen(data) {
            actionbar.popups.appendPopup(data.url);
            navigationbar.alertState = true;
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
