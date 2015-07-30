import QtQuick 2.1
import Sailfish.Silica 1.0

MouseArea
{
    property int radius
    property bool busy
    property real size
    property alias icon: favicon.source

    id: tabicon

    Rectangle
    {
        id: iconarea
        radius: tabicon.radius
        anchors { fill: parent; topMargin: -radius / 4; bottomMargin: -radius }
        color: pressed ? Theme.secondaryHighlightColor : "transparent"

        Rectangle
        {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: -radius }
            color: pressed ? Theme.rgba(parent.color, 0.5) : parent.color
            width: parent.radius
            z: -1
        }
    }


    BusyIndicator
    {
        id: busyindicator
        visible: busy
        running: busy
        anchors.centerIn: parent
        size: BusyIndicatorSize.Small
    }

    Image
    {
        id: favicon
        visible: !busy
        anchors.centerIn: parent
        width: size
        height: size
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: true
    }
}
