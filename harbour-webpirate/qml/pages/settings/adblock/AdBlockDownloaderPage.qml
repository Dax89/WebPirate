import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.AdBlock 1.0
import "../../../components"
import "../../../models"

Page
{
    property Settings settings
    property bool downloadingRules: false

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

            if(downloadingRules)
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

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Download CSS Filters")
                enabled: !adblockdownloader.downloading

                onClicked: {
                    downloadingRules = true;
                    adblockdownloader.downloadFilters(settings.adblockmanager)
                }
            }

            MenuItem
            {
                text: qsTr("Download Hosts BlackList")
                enabled: !adblockdownloader.downloading

                onClicked: {
                    downloadingRules = false;
                    adblockdownloader.downloadHosts(settings.adblockmanager)
                }
            }
        }

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
        }
    }
}
