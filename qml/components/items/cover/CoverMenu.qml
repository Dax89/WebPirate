import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu
{
    property string menuPosition: ""
    property int menuCategory: -1

    id: covermenu

    Repeater {
        model: settings.coveractions.actionmodel

        delegate: MenuItem {
            visible: categoryId <= menuCategory
            text: name
        }
    }
}
