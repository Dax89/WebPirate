import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/settings/PopupBlocker.js" as PopupBlocker

ListItem
{
    property alias popupDomain: lblpopup.text
    property int popupRule

    signal blockPopup()
    signal allowPopup()
    signal deleteRule()

    id: popupitem

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Block")
            onClicked: blockPopup()
        }

        MenuItem {
            text: qsTr("Allow")
            onClicked: allowPopup()
        }

        MenuItem {
            text: qsTr("Delete")

            onClicked: {
                popupitem.remorseAction(qsTr("Deleting rule"), function() {
                    deleteRule();
                });
            }
        }
    }

    Column
    {
        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }

        Label
        {
            id: lblpopup
            anchors { left: parent.left; right: parent.right }
            height: parent.height / 2
            color: Theme.highlightColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Row
        {
            anchors { left: parent.left; right: parent.right }
            height: parent.height / 2

            Label
            {
                anchors { top: parent.top; bottom: parent.bottom }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Rule") + ": "
            }

            Label
            {
                anchors { top: parent.top; bottom: parent.bottom }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                text: popupRule === PopupBlocker.AllowRule ? qsTr("Allow") : qsTr("Block")
                color: popupRule === PopupBlocker.AllowRule ? "lime" : "red"
            }
        }
    }
}
