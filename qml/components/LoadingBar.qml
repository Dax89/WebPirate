import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property real minimumValue: 0
    property real maximumValue: 100
    property real value: minimumValue

    Rectangle
    {
        id: progress
        width: (value / (maximumValue - minimumValue)) * parent.width
        color: Theme.highlightColor
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}
