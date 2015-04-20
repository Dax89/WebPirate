import QtQuick 2.1
import Sailfish.Silica 1.0
import "mediacomponents"
import "../../../../components"

Item
{
    property bool grabFailed: false
    property int videoDuration: 0
    property ListModel videoList: ListModel { }

    property alias grabResult: lblgrabresult.text
    property alias videoTitle: lbltitle.text
    property alias videoAuthor: lblauthor.text
    property alias videoThumbnail: imgthumbnail.source

    function addVideo(info, url)
    {
        videoList.append( {"videoinfo": info, "videourl": url });
    }

    function playVideo(videotitle, videourl, videothumbnail) {
        viewstack.push(Qt.resolvedUrl("BrowserPlayer.qml"), "mediaplayer", { "videoTitle": videotitle, "videoSource": videourl, "videoThumbnail": videothumbnail });
    }

    id: browsergrabber

    onVideoDurationChanged: {
        lblduration.text = timings.displayDuration(videoDuration);
    }

    MediaPlayerTimings { id: timings }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            anchors { top: parent.top; topMargin: Theme.paddingSmall }
            width: parent.width
            spacing: Theme.paddingMedium

            Column
            {
                id: column
                width: parent.width

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
                        id: lblgrabresult
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
                anchors { left: parent.left; right: parent.right }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                text: qsTr("Grabbed URLs") + ":"
                wrapMode: Text.WordWrap
            }

            Column
            {
                id: colvideotypes
                visible: !grabFailed
                anchors { left: parent.left; right: parent.right }

                Repeater
                {
                    model: videoList


                    delegate: ListItem {
                        id: lvitem
                        contentWidth: colvideotypes.width
                        contentHeight: Theme.itemSizeSmall
                        onClicked: playVideo(videoTitle, videourl, videoThumbnail)

                        menu: ContextMenu {
                            MenuItem {
                                text: qsTr("Play")
                                onClicked: playVideo(videoTitle, videourl, videoThumbnail)
                            }

                            MenuItem {
                                text: qsTr("Download")

                                onClicked: {
                                    lvitem.remorseAction(qsTr("Grabbing video"), function() {
                                        mainwindow.settings.downloadmanager.createDownloadFromUrl(videourl);
                                    });
                                }
                            }

                            MenuItem
                            {
                                text: qsTr("Copy URL")

                                onClicked: {
                                    popupmessage.show(qsTr("Link copied to clipboard"));
                                    Clipboard.text = videourl;
                                }
                            }
                        }

                        InfoLabel
                        {
                            anchors.fill: parent
                            labelElide: Text.ElideRight
                            displayColon: false
                            title: videoinfo
                            text: videourl
                        }
                    }
                }
            }
        }
    }
}
