import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/PopupBlocker.js" as PopupBlocker

ListItem
{
    property alias blockedUrl: lblurl.text

    signal allowPopup()
    signal deleteRule()

    id: blockedpopupitem

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Allow")
            onClicked: allowPopup()
        }

        MenuItem {
            text: qsTr("Delete")

            onClicked: {
                blockedpopupitem.remorseAction(qsTr("Deleting rule"), function() {
                    deleteRule();
                });
            }
        }
    }

    Label
    {
        id: lblurl
        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}
