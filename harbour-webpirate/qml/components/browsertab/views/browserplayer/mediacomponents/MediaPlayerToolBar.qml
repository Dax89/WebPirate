import QtQuick 2.1
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "../../../../navigationbar"
import "../../../../../js/UrlHelper.js" as UrlHelper

Rectangle
{
    readonly property bool canClick: opacity > 0.1

    function keepVisible(keep) {
        if(!keep) {
            timerdissolve.restart();
            return;
        }

        timerdissolve.stop()
        toolbar.opacity = 1.0;
    }

    function restoreOpacity() {
        toolbar.opacity = 1.0;
        timerdissolve.restart();
    }

    id: toolbar
    color: Theme.highlightDimmerColor
    visible: Qt.application.state === Qt.ApplicationActive
    z: 10

    Behavior on opacity { NumberAnimation { duration: 800; easing.type: Easing.Linear } }
    PanelBackground { anchors.fill: parent }
    MouseArea { anchors.fill: parent; onClicked: restoreOpacity() }

    Timer
    {
        id: timerdissolve
        interval: 2000

        onTriggered: {
            toolbar.opacity = 0.0;
        }
    }

    ImageButton
    {
        id: btndownload
        width: Theme.itemSizeSmall
        enabled: browserplayer.state !== "error"
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        source: "image://theme/icon-m-cloud-download"
        z: 10

        onClicked: {
            if(browserplayer.state !== "error")
                restoreOpacity();

            if(!canClick)
                return;

            tabviewremorse.execute(qsTr("Downloading media"), function() {
                if(browserplayer.videoTitle.length > 0) {
                    var mime = mainwindow.settings.mimedatabase.mimeFromUrl(browserplayer.videoSource);
                    var mimeinfo = mime.split("/");
                    mainwindow.settings.downloadmanager.createDownloadFromUrl(browserplayer.videoSource, browserplayer.videoTitle + "." + mimeinfo[1]);
                    return;
                }

                mainwindow.settings.downloadmanager.createDownloadFromUrl(browserplayer.videoSource);
            });
        }
    }

    MediaPlayerProgressBar
    {
        id: pbbuffer
        anchors { left: btndownload.right; right: btntbs.left; verticalCenter: parent.verticalCenter }
        bufferMinimum: 0
        bufferMaximum: 1.0
        bufferValue: videoplayer.bufferProgress
        progressMinimum: 0
        progressMaximum: videoplayer.duration
        progressValue: videoplayer.position
        onDragChanged: keepVisible(dragging)

        onSeekRequested: {
            if(browserplayer.state !== "error")
                restoreOpacity();

            if(!canClick)
                return;

            if(videoplayer.seekable)
                videoplayer.seek(seekpos);
        }
    }

    ImageButton
    {
        id: btntbs
        anchors { right: btnclose.left; top: parent.top; bottom: parent.bottom; rightMargin: -Theme.paddingMedium }
        width: Theme.itemSizeSmall
        source: "image://theme/icon-m-tabs"
        z: 10

        onClicked: {
            if(browserplayer.state !== "error")
                restoreOpacity();

            if(!canClick)
                return;

            pageStack.push(Qt.resolvedUrl("../../../../../pages/segment/SegmentsPage.qml"), { "settings": mainwindow.settings, "tabView": tabView });
        }

        Label { anchors.centerIn: parent; font.pixelSize: Theme.fontSizeSmall; font.bold: true; text: tabView.tabs.count; z: -1 }
    }

    ImageButton
    {
        id: btnclose
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: Theme.paddingMedium }
        width: Theme.itemSizeSmall
        source: "image://theme/icon-close-app"
        z: 10

        onClicked: {
            if(browserplayer.state !== "error")
                restoreOpacity();

            if(!canClick)
                return;

            viewstack.pop();
        }
    }
}
