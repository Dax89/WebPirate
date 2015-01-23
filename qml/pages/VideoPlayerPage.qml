import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "../components/mediaplayer"

Page
{
    property alias videoSource: videoplayer.source
    property alias videoThumbnail: imgthumbnail.source
    property alias videoTitle: mptitle.text

    id: videoplayerpage
    allowedOrientations: Orientation.All
    showNavigationIndicator: videoplayer.playbackState !== MediaPlayer.PlayingState

    states: [ State { name: "error";
                      PropertyChanges { target: lblmessage; visible: true }
                      PropertyChanges { target: pcbusy; visible: false } },
              State { name: "loading"
                      PropertyChanges { target: lblmessage; visible: false }
                      PropertyChanges { target: pcbusy; visible: true } } ]

    Rectangle
    {
        id: errorframe
        anchors.fill: parent
        color: "black"

        Label
        {
            id: lblmessage
            anchors.centerIn: parent
            text: videoplayer.errorString
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "white"
        }
    }

    Video
    {
        id: videoplayer
        anchors.fill: parent
        autoPlay: true
        onPlaybackStateChanged: {
            var keep = videoplayer.playbackState !== MediaPlayer.PlayingState;
            mptoolbar.keepVisible(keep);
            mptitle.keepVisible(keep);
        }

        onErrorChanged: {
            videoplayerpage.state = (videoplayer !== MediaPlayer.NoError ? "" : "error");
        }

        onStatusChanged: {
            videoplayerpage.state = (status === MediaPlayer.Loading || status === MediaPlayer.Buffering || status === MediaPlayer.Stalled) ? "loading" : "";
        }

        Image
        {
            id: imgthumbnail
            width: videplayer.height / 2
            height: videplayer.height / 2
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            visible: !videoplayer.hasVideo
        }

        BusyIndicator
        {
            id: pcbusy
            anchors.centerIn: parent
            visible: false
            running: visible
        }

        MouseArea
        {
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: mptoolbar.top }

            onClicked: {
                if(mptoolbar.opacity < 1.0) {
                    mptoolbar.restoreOpacity();
                    mptitle.restoreOpacity();
                    return;
                }

                videoplayer.playbackState === MediaPlayer.PlayingState ? videoplayer.pause() : videoplayer.play();
            }
        }

        MediaPlayerTitle
        {
            id: mptitle
            anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.paddingMedium; topMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
        }

        MediaPlayerToolBar
        {
            id: mptoolbar
            video: videoplayer
            height: Theme.itemSizeSmall
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right; }
        }
    }
}
