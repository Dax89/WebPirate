import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate.AdBlock 1.0
import "../../components"
import "../../models"

Page
{
    property Settings settings

    signal rulesDownloaded()

    id: adblockdownloaderpage
    allowedOrientations: defaultAllowedOrientations

    AdBlockDownloader
    {
        id: adblockdownloader

        onConnectionStarted: {
            downloadinfo.text = qsTr("Connecting") + "...";
        }

        onDownloadCompleted: {
            downloadinfo.text = qsTr("Completed");
            rulesDownloaded();
        }

        onDownloadError: {
            downloadinfo.text = qsTr("Error") + ": " + errormessage;
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            PageHeader { title: qsTr("AdBlock Updater") }

            InfoLabel
            {
                id: downloadinfo
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                title: qsTr("State")
                text: qsTr("Ready")
            }

            ProgressBar
            {
                id: progressbar
                anchors { left: parent.left; right: parent.right }
                minimumValue: 0
                maximumValue: adblockdownloader.progressTotal
                value: adblockdownloader.progressValue
            }

            Button
            {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Download")
                enabled: !adblockdownloader.downloading
                onClicked: adblockdownloader.downloadFilters(settings.adblockmanager)
            }
        }
    }
}
