import QtQuick 2.1
import Sailfish.Silica 1.0
import ".."

ListItem
{
    property alias videoInfo: infolabel.title
    property alias videoUrl: infolabel.text
    property string videoThumbnail
    property string videoTitle

    function playVideo() {
        viewstack.push(Qt.resolvedUrl("../browsertab/views/browserplayer/BrowserPlayer.qml"), "mediaplayer",
                       { "videoTitle": videoTitle, "videoSource": videoUrl, "videoThumbnail": videoThumbnail });
    }

    id: grabberitem
    onClicked: playVideo()

    menu: ContextMenu {
        MenuItem
        {
            text: qsTr("Play")
            onClicked: playVideo()
        }

        MenuItem
        {
            text: qsTr("Download")

            onClicked: {
                grabberitem.remorseAction(qsTr("Grabbing video"), function() {
                    var ext = videomime.split("/")[1];
                    settings.downloadmanager.createDownloadFromUrl(videoUrl, videoTitle + "." + ext);
                });
            }
        }

        MenuItem
        {
            text: qsTr("Copy URL")

            onClicked: {
                popupmessage.show(qsTr("Link copied to clipboard"));
                settings.clipboard.copy(videoUrl);
            }
        }
    }

    InfoLabel
    {
        id: infolabel
        anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        height: parent.contentHeight
        labelElide: Text.ElideRight
        displayColon: false
    }
}

