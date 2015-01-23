import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0

Rectangle
{
    property Video video

    function keepVisible(keep)
    {
        if(!keep)
        {
            timerdissolve.restart();
            return;
        }

        timerdissolve.stop()
        toolbar.opacity = 1.0;
    }

    function restoreOpacity()
    {
        toolbar.opacity = 1.0;
        timerdissolve.restart();
    }

    id: toolbar
    color: Theme.highlightDimmerColor
    z: 1

    Behavior on opacity { NumberAnimation { duration: 800; easing.type: Easing.Linear } }

    MouseArea
    {
        anchors.fill: parent
        onClicked: restoreOpacity()
    }

    Timer
    {
        id: timerdissolve
        interval: 2000

        onTriggered: {
            toolbar.opacity = 0.0;
        }
    }

    IconButton
    {
        id: btnplaystop
        width: Theme.itemSizeSmall
        height: Theme.itemSizeSmall
        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
        icon.source: video.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-m-pause" : "image://theme/icon-m-play"
        z: 1

        onClicked: {
            restoreOpacity();
            video.playbackState === MediaPlayer.PlayingState ? video.pause() : video.play();
        }
    }

    MediaPlayerProgressBar
    {
        id: pbbuffer
        anchors { left: btnplaystop.right; right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: Theme.paddingMedium }
        width: parent.width - btnplaystop.width
        bufferMinimum: 0
        bufferMaximum: 1.0
        bufferValue: video.bufferProgress
        progressMinimum: 0
        progressMaximum: video.duration
        progressValue: video.position

        onSeekRequested: {
            restoreOpacity();

            if(video.seekable)
                video.seek(seekpos);
        }
    }
}
