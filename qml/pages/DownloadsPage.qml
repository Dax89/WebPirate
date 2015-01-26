import QtQuick 2.1
import Sailfish.Silica 1.0
import "../models"
import "../components/items"

Page
{
    property Settings settings

    id: downloadpage
    allowedOrientations: Orientation.All

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete completed Downloads")
                onClicked: settings.downloadmanager.removeCompleted()
            }
        }

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
            model: settings.downloadmanager.count

            delegate: DownloadListItem {
                contentHeight: Theme.itemSizeLarge
                width: parent.width
                downloadItem: settings.downloadmanager.downloadItem(index)
            }
        }
    }
}
