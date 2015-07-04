import QtQuick 2.1
import Sailfish.Silica 1.0

MouseArea
{
    property int radius
    readonly property int contentHeight: height - (-radius + (-radius / 4))

    id: tabclosebutton
    anchors { topMargin: -radius / 4; bottomMargin: -radius }

    Rectangle
    {
        id: closearea
        radius: tabclosebutton.radius
        anchors.fill: parent
        color: pressed ? Theme.secondaryHighlightColor : "transparent"

        Rectangle
        {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            color: pressed ? Theme.rgba(parent.color, 0.1) : parent.color
            width: parent.radius
        }
    }

    Image
    {
        width: contentHeight * 0.5
        height: contentHeight * 0.5
        anchors { verticalCenter: parent.verticalCenter; verticalCenterOffset: -radius / 4; horizontalCenter: parent.horizontalCenter; }
        source: "qrc:///res/close.png"
    }
}
