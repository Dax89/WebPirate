import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property bool lockHeight: false
    readonly property real contentHeight: Theme.itemSizeSmall

    function solidify() {
        height = contentHeight;
    }

    function evaporate() {
        if(lockHeight) { // Disallow evaporation
            solidify();
            return;
        }

        height = 0;
    }

    Behavior on height {
        PropertyAnimation { duration: 250; easing.type: Easing.Linear }
    }

    PanelBackground { anchors.fill: parent }

    id: browserbar
    height: contentHeight
    visible: height > 0
    color: Theme.highlightDimmerColor
    clip: true
    z: 50
}
