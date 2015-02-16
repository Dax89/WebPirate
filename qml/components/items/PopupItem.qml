import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/PopupBlocker.js" as PopupBlocker

ListItem
{
    property alias popupDomain: lblpopup.text
    property int popupRule

    id: popupitem

    Label
    {
        id: lblpopup
        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: popupRule === PopupBlocker.BlockRule ? "red" : Theme.primaryColor
    }
}
