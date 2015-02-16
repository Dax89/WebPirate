import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/tabview"
import "../../components/items"

Page
{
    property TabView tabView

    id: closedtabspage
    orientation: Orientation.All

    function openTab(url, index) {
        tabView.addTab(url);
        tabView.closedtabs.remove(index);
        pageStack.pop();
    }

    RemorsePopup { id: remorsepopup }

    SilicaListView
    {
        PullDownMenu
        {
            MenuItem {
                text: qsTr("Delete Closed Tabs")

                onClicked: remorsepopup.execute(qsTr("Deleting Tabs"), function() {
                    tabView.closedtabs.clear();
                });
            }
        }

        id: listview
        anchors.fill: parent
        model: tabView.closedtabs

        header: PageHeader { title: qsTr("Closed Tabs") }

        delegate: ClosedTabItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            tabTitle: title
            tabUrl: url

            onClicked: openTab(url, index)
            onOpenRequested: openTab(url, index)
            onDeleteRequested: tabView.closedtabs.remove(index)
        }
    }
}
