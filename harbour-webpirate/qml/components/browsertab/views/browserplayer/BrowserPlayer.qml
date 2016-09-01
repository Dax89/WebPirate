import QtQuick 2.1
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "mediacomponents"

Item
{
    property alias videoSource: videoplayer.source
    property alias videoThumbnail: imgthumbnail.source
    property alias videoTitle: mptitle.text

    id: browserplayer

    states: [ State { name: "error"
                      PropertyChanges { target: mperror; showError: true }
                      PropertyChanges { target: pcbusy; visible: false } },

              State { name: "loading"
                      PropertyChanges { target: mperror; showError: false }
                      PropertyChanges { target: pcbusy; visible: true } },

              State { name: "playing"
                      PropertyChanges { target: mperror; showError: false }
                      PropertyChanges { target: pcbusy; visible: false } }]

    onStateChanged: {
        if((state === "") || (state === "error"))
            mptoolbar.keepVisible(true);
    }

    Timer
    {
        id: screenping
        repeat: true
        triggeredOnStart: true
        interval: 60000 /* 60s */
        running: browserplayer.visible && (videoplayer.playbackState === MediaPlayer.PlayingState)

        onTriggered: {
            mainwindow.settings.screenblank.enabled = false;
        }
    }

    Video
    {
        id: videoplayer
        anchors.fill: parent
        autoPlay: false

        onPlaybackStateChanged: {
            var keep = videoplayer.playbackState !== MediaPlayer.PlayingState;

            mptoolbar.keepVisible(keep);
            mptitle.keepVisible(keep);

            if(videoplayer.playbackState === MediaPlayer.PlayingState)
                browserplayer.state = "playing";
        }

        onErrorChanged: {
            if(videoplayer !== MediaPlayer.NoError) {
                browserplayer.state = "error";
                videoplayer.stop(); // Avoid MediaPlayer undefined behavior
            }
        }

        onStatusChanged: {
            if((playbackState !== MediaPlayer.PlayingState) && (status === MediaPlayer.Loading || status === MediaPlayer.Buffering || status === MediaPlayer.Stalled))
                browserplayer.state = "loading";
        }

        onBufferProgressChanged: {
            if((bufferProgress < 1.0) || (status === MediaPlayer.PausedState))
                return;

            videoplayer.play();
        }

        Image { id: imgthumbnail; fillMode: Image.PreserveAspectFit; anchors.centerIn: parent; visible: !mperror.showError && !videoplayer.hasVideo; z: 2 }
        BusyIndicator { id: pcbusy; anchors.centerIn: parent; visible: false; running: visible; size: BusyIndicatorSize.Large; z: 3 }

        MouseArea
        {
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: mptoolbar.top }

            onClicked: {
                if(mptoolbar.opacity < 1.0) {
                    mptoolbar.restoreOpacity();
                    mptitle.restoreOpacity();
                    return;
                }

                if(videoplayer.playbackState === MediaPlayer.PlayingState) {
                    videoplayer.pause();
                    mppopup.animatePause();
                }
                else {
                    videoplayer.play();
                    mppopup.animatePlay();
                }
            }

            MediaPlayerPopup { id: mppopup; anchors.centerIn: parent }
        }

        MediaPlayerError { id: mperror; anchors.fill: parent; errorMessage: videoplayer.errorString }

        MediaPlayerTitle
        {
            id: mptitle
            anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.paddingMedium; topMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
        }

        MediaPlayerToolBar { id: mptoolbar; height: Theme.itemSizeSmall; anchors { left: parent.left; bottom: parent.bottom; right: parent.right } }
    }

    CoverActionList /* Media Player Cover Actions */
    {
        enabled: browserplayer.visible && (browserplayer.state !== "error")
        iconBackground: true

        CoverAction
        {
            iconSource: videoplayer.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: videoplayer.playbackState === MediaPlayer.PlayingState ? videoplayer.pause() : videoplayer.play();
        }

        CoverAction
        {
            iconSource: "image://theme/icon-cover-cancel"
            onTriggered: viewstack.clear()
        }
    }

    CoverActionList /* Media Player Fallback Cover Actions */
    {
        enabled: browserplayer.visible && (browserplayer.state === "error")
        iconBackground: true

        CoverAction
        {
            iconSource: "image://theme/icon-cover-cancel"
            onTriggered: viewstack.clear()
        }
    }
}
