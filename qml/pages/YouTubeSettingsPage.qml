import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"
import "../models"
import "../js/YouTubeGrabber.js" as YouTubeGrabber

Page
{
    property string videoId
    property ListModel videoTypes: ListModel { }
    property Settings settings

    property bool grabFailed: false
    property alias videoResponse: lblresponse.text
    property alias videoTitle: lbltitle.text
    property alias videoAuthor: lblauthor.text
    property alias videoDuration: lblduration.text
    property alias videoThumbnail: imgthumbnail.source

    function playVideo(videotitle, videourl, videothumbnail) {
        pageStack.replace(Qt.resolvedUrl("VideoPlayerPage.qml"), { "videoTitle": videotitle, "videoSource": videourl, "videoThumbnail": videothumbnail });
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
                visible: !grabFailed

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

            Column
            {
                id: colvideo
                width: parent.width
                spacing: Theme.paddingMedium

                InfoLabel
                {
                    id: lblresponse
                    anchors.topMargin: Theme.paddingMedium
                    width: parent.width
                    contentColor: grabFailed ? "red" : "lime"
                    title: qsTr("Response")
                    text: "OK"
                    labelWrap: Text.WordWrap
                }

                InfoLabel
                {
                    id: lbltitle
                    visible: !grabFailed
                    anchors.topMargin: Theme.paddingMedium
                    width: parent.width
                    title: qsTr("Title")
                    labelWrap: Text.WordWrap
                }
            }
        }

        Label
        {
            id: lblgrabs
            visible: !grabFailed
            anchors { left: parent.left; top: column.bottom; right: parent.right; topMargin: Theme.paddingLarge }
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            text: qsTr("Grabbed URLs") + ":"
            wrapMode: Text.WordWrap
        }

        ListView
        {
            id: lvvideotypes
            visible: !grabFailed
            anchors { left: parent.left; top: lblgrabs.bottom; right: parent.right; bottom: parent.bottom; topMargin: Theme.paddingMedium; }
            model: videoTypes
            clip: true

            delegate: ListItem {
                id: lvitem
                contentWidth: lvvideotypes.width
                contentHeight: Theme.itemSizeSmall
                onClicked: playVideo(videoTitle, url, videoThumbnail)

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Play")
                        onClicked: playVideo(videoTitle, url, videoThumbnail)
                    }

                    MenuItem {
                        text: qsTr("Download")

                        onClicked: {
                            lvitem.remorseAction(qsTr("Grabbing video"), function() {
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
