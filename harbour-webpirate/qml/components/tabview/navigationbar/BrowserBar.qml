import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property real extraHeight: 0
    property bool lockHeight: false
    readonly property real calculatedHeight: Theme.itemSizeSmall + extraHeight

    function solidify() {
        height = calculatedHeight;
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
    height: calculatedHeight
    visible: height > 0
    color: Theme.rgba(Theme.highlightDimmerColor, 1.0)
    clip: true
    z: 50
}
