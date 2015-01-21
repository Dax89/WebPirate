import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../models"
import "../js/YouTubeGrabber.js" as YouTubeGrabber

Page
{
    property string videoId
    property ListModel videoTypes: ListModel { }
    property Settings settings

    property alias videoTitle: lbltitle.text
    property alias videoAuthor: lblauthor.text
    property alias videoDuration: lblduration.text
    property alias videoThumbnail: imgthumbnail.source

    function playVideo(videotitle, videourl) {
        pageStack.replace(Qt.resolvedUrl("VideoPlayerPage.qml"), { "videoTitle": videotitle, "videoSource": videourl });
    }

    id: dlgytvideosettings
    allowedOrientations: Orientation.All
    onVideoIdChanged: YouTubeGrabber.grabVideo(videoId, dlgytvideosettings);

    SilicaFlickable
    {
        anchors.fill: parent

        PageHeader { id: dlgheader; title: qsTr("YouTube Grabber") }

        Column
        {
            id: column
            anchors { left: parent.left; top: dlgheader.bottom; right: parent.right }

            Row
            {
                id: videoinfo
                width: parent.width
                height: Math.max(imgthumbnail.height, colinfo.height)
                spacing: Theme.paddingSmall

                Image
                {
                    id: imgthumbnail
                    width: 240
                    height: 130
                    fillMode: Image.PreserveAspectCrop
                }

                Column
                {
                    id: colinfo
                    width: parent.width - imgthumbnail.width
                    spacing: Theme.paddingMedium

                    InfoLabel {
                        id: lblauthor
                        width: parent.width
                        title: qsTr("Author")
                    }

                    InfoLabel {
                        id: lblduration
                        width: parent.width
                        title: qsTr("Duration")
                    }
                }
            }

            InfoLabel
            {
                id: lbltitle
                anchors.topMargin: Theme.paddingMedium
                width: parent.width
                title: qsTr("Title")
                labelWrap: Text.WordWrap
            }
        }

        Label
        {
            id: lblgrabs
            anchors { left: parent.left; top: column.bottom; right: parent.right; topMargin: Theme.paddingLarge }
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            text: qsTr("Grabbed URLs") + ":"
            wrapMode: Text.WordWrap
        }

        ListView
        {
            id: lvvideotypes
            anchors { left: parent.left; top: lblgrabs.bottom; right: parent.right; bottom: parent.bottom; topMargin: Theme.paddingMedium; }
            model: videoTypes
            clip: true

            delegate: ListItem {
                id: lvitem
                contentWidth: lvvideotypes.width
                contentHeight: Theme.itemSizeSmall
                onClicked: playVideo(videoTitle, url)

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Play")
                        onClicked: playVideo(videoTitle, url)
                    }

                    MenuItem {
                        text: qsTr("Download")

                        onClicked: {
                            lvitem.remorseAction(qsTr("Downloading video"), function() {
                                settings.downloadmanager.createDownload(url);
                            });
                        }
                    }
                }

                InfoLabel
                {
                    anchors.fill: parent
                    labelElide: Text.ElideRight
                    displayColon: false
                    title: qsTr("Quality") + ": " + (quality + " (" + mime + (hascodec ? (", " + codec) : "") + ")")
                    text: url
                }
            }
        }
    }
}
