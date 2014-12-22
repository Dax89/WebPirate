import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../models"

Page
{
    property Settings settings

    id: downloadpage
    allowedOrientations: Orientation.All

    PageHeader {
        id: pageheader
        title: qsTr("Download Manager")
    }

    SilicaListView
    {
        anchors.top: pageheader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: settings.downloadmanager

        delegate: ListItem {
            property bool downloading: true

            id: downloaditem
            contentHeight: Theme.itemSizeLarge
            width: parent.width

            menu: Component {
                ContextMenu {
                    MenuItem {
                        text: qsTr("Restart");
                        onClicked: settings.downloadmanager.restartDownload(settings.downloadmanager.get(index));
                    }

                    MenuItem {
                        text: qsTr("Cancel")
                        visible: downloaditem.downloading
                        onClicked: {
                            settings.downloadmanager.cancelDownload(settings.downloadmanager.get(index));
                        }
                    }
                }
            }

            Component.onCompleted: {
                imgstate.source = "image://theme/icon-m-play";

                downloader.succeeded.connect(function() {
                    downloadtimer.stop();

                    imgstate.source = "image://theme/icon-m-tab"
                    lblspeed.text = "Finished";
                    downloading = false;
                });

                downloader.failed.connect(function(error, url, description) {
                    downloadtimer.stop();

                    imgstate.source = "image://theme/icon-m-tab"
                    lblspeed.text = description;
                    downloading = false;
                });
            }

            Timer {
                id: downloadtimer
                interval: 1000
                repeat: true
                running: true

                onTriggered: {
                     lblspeed.text = qsTr("Speed:") + " " + settings.downloadmanager.calculateSpeed(settings.downloadmanager.get(index));
                }
            }

            Column {
                id: column
                anchors.fill: parent
                anchors.margins: Theme.paddingMedium

                Row {
                    width: parent.width
                    height: Theme.itemSizeLarge / 3

                    Image {
                        id: imgstate
                        height: parent.height
                        width: parent.height
                    }

                    Label {
                        height: parent.height
                        width: parent.width - imgstate.width
                        font.pixelSize: Theme.fontSizeExtraSmall
                        verticalAlignment: Text.AlignVCenter
                        text: downloader.suggestedFilename
                        elide: Text.ElideRight
                        clip: true
                    }
                }

                Row {
                    width: parent.width
                    height: Theme.itemSizeLarge / 3
                    spacing: Theme.paddingSmall

                    Label {
                        id: lblspeed
                        height: parent.height
                        width: parent.width / 2
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                        clip: true
                    }

                    Label {
                        id: lblprogress
                        height: parent.height
                        width: parent.width / 2
                        text: qsTr("Completed:") + " " + progressbar.value + "%"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }

                LoadingBar {
                    id: progressbar
                    width: parent.width
                    height: 4
                    minimumValue: 0
                    maximumValue: 100
                    value: Math.round((downloader.totalBytesReceived / downloader.expectedContentLength) * 100);
                }
            }
        }
    }
}
