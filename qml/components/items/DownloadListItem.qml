import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate.Private 1.0
import "../browsertab/navigationbar"

ListItem
{
    property DownloadItem downloadItem

    id: downloadlistitem

    function updateProgressValue() {
        lblspeed.text = qsTr("Speed:") + " " + downloadItem.speed;
    }

    function checkCompletedState() {
        if(downloadItem.completed)
            lblspeed.text = qsTr("Completed");
    }

    function downloadError(message) {
        lblspeed.text = qsTr("Error:") + " " + message;
    }

    menu: Component {
        ContextMenu {
            MenuItem {
                text: qsTr("Cancel")
                visible: !downloadItem.completed
                onClicked: downloadItem.cancel()
            }
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
                source: downloadItem.completed ? "image://theme/icon-m-tab" : "image://theme/icon-m-download"
            }

            Label {
                id: lblfilename
                height: parent.height
                width: parent.width - imgstate.width
                font.pixelSize: Theme.fontSizeExtraSmall
                verticalAlignment: Text.AlignVCenter
                text: downloadItem.fileName
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
                width: downloadItem.error ? 0 : (parent.width / 2)
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                clip: true
            }

            Label {
                id: lblprogress
                height: parent.height
                width: downloadItem.error ? parent.width : (parent.width / 2)
                text: downloadItem.error ? downloadItem.lastError : (qsTr("Completed:") + " " + progressbar.value + "%")
                color: downloadItem.error ? "red" : Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        LoadingBar {
            id: progressbar
            width: parent.width
            backColor: "white"
            barHeight: 8
            minimumValue: 0
            maximumValue: 100
            value: Math.round((downloadItem.progressValue / downloadItem.progressTotal) * 100)
        }
    }

    onDownloadItemChanged: {
        downloadItem.progressValueChanged.connect(updateProgressValue);
        downloadItem.completedChanged.connect(checkCompletedState);
    }

    Component.onDestruction: {
        downloadItem.completedChanged.disconnect(checkCompletedState);
        downloadItem.progressValueChanged.disconnect(updateProgressValue);
    }
}
