import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/tabview"
import "../../components/items"
import "../../js/Database.js" as Database
import "../../js/PopupBlocker.js" as PopupBlocker

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
            MenuItem {
                text: qsTr("Clear popup list")
                onClicked: popupModel.clear();
            }
        }

        PageHeader { id: pageheader; title: qsTr("Popup Blocker") }

        SilicaListView
        {
            id: listview
            anchors { left: parent.left; top: pageheader.bottom; right: parent.right; bottom: parent.bottom }

            delegate: BlockedPopupItem {
                id: listitem
                contentWidth: parent.width
                contentHeight: Theme.itemSizeSmall
                blockedUrl: url

                onAllowPopup: PopupBlocker.setRule(Database.instance(), url, PopupBlocker.AllowRule)
                onDeleteRule: PopupBlocker.setRule(Database.instance(), url, PopupBlocker.NoRule)

                onClicked: {
                    tabView.addTab(url);
                    popupModel.remove(index);
                    pageStack.pop();
                }
            }
        }
    }
}
