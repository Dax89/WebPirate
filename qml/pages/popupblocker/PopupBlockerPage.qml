import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/tabview"

Page
{
    property alias popupModel: listview.model
    property TabView tabView

    id: popupblockerpage
    allowedOrientations: Orientation.All

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Clear popup list")
                onClicked: popupModel.clear()
            }
        }

        PageHeader { id: pageheader; title: qsTr("Popup Blocker") }

        SilicaListView
        {
            id: listview
            anchors { left: parent.left; top: pageheader.bottom; right: parent.right; bottom: parent.bottom }

            delegate: ListItem {
                id: listitem
                contentWidth: parent.width
                contentHeight: Theme.itemSizeSmall

                onClicked: {
                    tabView.addTab(url);
                    popupModel.remove(index);
                    pageStack.pop();
                }

                Label
                {
                    anchors { fill: parent; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: url
                }
            }
        }
    }
}
