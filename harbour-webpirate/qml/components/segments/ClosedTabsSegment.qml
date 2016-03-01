import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../items/tab"

SilicaListView
{
    function load() { }
    function unload() { }

    PullDownMenu
    {
        MenuItem
        {
            text: qsTr("Delete Closed Tabs")
            onClicked: tabView.closedtabs.clear();
        }
    }

    id: closedtabssegment
    clip: true
    model: tabView.closedtabs

    function openTab(url, index) {
        tabView.addTab(url);
        tabView.closedtabs.remove(index);
    }

    header: PageHeader {
        id: pageheader
        title: qsTr("Closed Tabs")
    }

    delegate: TabClosedItem {
        contentWidth: closedtabssegment.width
        contentHeight: Theme.itemSizeSmall
        tabTitle: title
        tabUrl: url

        onClicked: openTab(url, index)
        onOpenRequested: openTab(url, index)
        onDeleteRequested: tabView.closedtabs.remove(index)
    }
}
