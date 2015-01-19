import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0

Page
{
    property alias videoSource: video.source

    id: videoplayerpage
    allowedOrientations: Orientation.All

    states: [ State { name: "error";
                      PropertyChanges { target: lblmessage; visible: true }
                      PropertyChanges { target: pcprogress; visible: false } },
              State { name: "loading"
                      PropertyChanges { target: lblmessage; visible: false }
                      PropertyChanges { target: pcprogress; visible: true } } ]

    Rectangle
    {
        id: errorframe
        anchors.fill: parent
        color: "black"

        Label
        {
            id: lblmessage
            anchors.centerIn: parent
            text: video.errorString
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "white"
        }
    }

    Video
    {
        id: video
        anchors.fill: parent

        onErrorChanged: {
            videoplayerpage.state = (video !== MediaPlayer.NoError ? "" : "error");
        }

        onStatusChanged: {
            videoplayerpage.state = (status === MediaPlayer.Loading || status === MediaPlayer.Buffering || status === MediaPlayer.Stalled) ? "loading" : "";
        }

        BusyIndicator
        {
            id: pcprogress
            anchors.centerIn: parent
            visible: false
            running: visible
        }

        MouseArea
        {
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: toolbar.top }
            onClicked: video.play();
        }

        Rectangle
        {
            id: toolbar
            color: Theme.highlightDimmerColor
            height: Theme.itemSizeSmall
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }

            Row
            {
                anchors.fill: parent
                spacing: Theme.paddingSmall

                IconButton
                {
                    id: btnplaystop
                    width: Theme.itemSizeSmall
                    height: Theme.itemSizeSmall
                    icon.source: video.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-m-pause" : "image://theme/icon-m-play"
                    onClicked: video.playbackState === MediaPlayer.PlayingState ? video.pause() : video.play()
                }

                ProgressBar
                {
                    id: pbbuffer
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - btnplaystop.width
                    minimumValue: 0
                    maximumValue: video.duration
                    value: video.position
                }
            }
        }
    }
}
