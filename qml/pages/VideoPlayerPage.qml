import QtQuick 2.1
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
    showNavigationIndicator: (Qt.application.state === Qt.ApplicationActive) && (lblmessage.visible || (videoplayer.playbackState !== MediaPlayer.PlayingState))

    states: [ State { name: "error";
                      PropertyChanges { target: lblmessage; visible: true }
                      PropertyChanges { target: pcbusy; visible: false } },
              State { name: "loading"
                      PropertyChanges { target: lblmessage; visible: false }
                      PropertyChanges { target: pcbusy; visible: true } } ]

    Rectangle
    {
        id: blackframe
        anchors.fill: parent
        color: "black"

        Label
        {
            id: lblmessage
            anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
            width: parent.width
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
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            visible: !lblmessage.visible && !videoplayer.hasVideo
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
            height: Theme.itemSizeSmall
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right; }
        }
    }

    CoverActionList /* Media Player Cover Actions */
    {
        enabled: (videoplayerpage.status === PageStatus.Active) && !lblmessage.visible
        iconBackground: true

        CoverAction
        {
            iconSource: videoplayer.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: videoplayer.playbackState === MediaPlayer.PlayingState ? videoplayer.pause() : videoplayer.play();
        }

        CoverAction
        {
            iconSource: "image://theme/icon-cover-cancel"
            onTriggered: pageStack.pop()
        }
    }

    CoverActionList /* Media Player Fallback Cover Actions */
    {
        enabled: (videoplayerpage.status === PageStatus.Active) && lblmessage.visible
        iconBackground: true

        CoverAction
        {
            iconSource: "image://theme/icon-cover-cancel"
            onTriggered: pageStack.pop()
        }
    }
}
