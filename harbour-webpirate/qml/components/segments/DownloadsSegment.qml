import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/items"
import "../../js/UrlHelper.js" as UrlHelper

SilicaListView
{
    function load() { }
    function unload() { }

    PullDownMenu
    {
        MenuItem
        {
            text: qsTr("Delete completed Downloads")
            onClicked: settings.downloadmanager.removeCompleted()
        }
    }

    id: downloadssegment
    clip: true
    model: settings.downloadmanager.count

    header: Column {
        width: downloadssegment.width

        PageHeader {
            title: qsTr("Downloads")
        }

        Row
        {
            anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
            spacing: Theme.paddingSmall

            Text { id: fakebtntext; visible: false; text: qsTr("Start"); }

            TextField
            {
                id: tfdownloadurl
                width: parent.width - btnstart.width - (Theme.paddingSmall * 2)
                labelVisible: false
                textLeftMargin: Theme.paddingSmall
                placeholderText: qsTr("Download Url")
            }

            Button
            {
                id: btnstart
                text: fakebtntext.text
                width: fakebtntext.contentWidth + (2 * Theme.paddingMedium)
                height: tfdownloadurl.height
                enabled: (tfdownloadurl.text.length > 0) && UrlHelper.isUrl(tfdownloadurl.text)
                onClicked: settings.downloadmanager.createDownloadFromUrl(tfdownloadurl.text);
            }
        }
    }

    delegate: DownloadListItem {
        contentHeight: Theme.itemSizeLarge
        width: downloadssegment.width
        downloadItem: settings.downloadmanager.downloadItem(index)
    }
}
