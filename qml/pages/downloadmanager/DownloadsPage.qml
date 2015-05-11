import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/items"

Page
{
    property Settings settings

    id: downloadpage
    allowedOrientations: defaultAllowedOrientations

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete completed Downloads")
                onClicked: settings.downloadmanager.removeCompleted()
            }

            MenuItem {
                text: qsTr("New Download")

                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NewDownloadPage.qml"));

                    dialog.accepted.connect(function() {
                        settings.downloadmanager.createDownloadFromUrl(dialog.downloadUrl);
                    });
                }
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
