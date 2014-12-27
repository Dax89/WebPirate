import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property real minimumValue: 0
    property real maximumValue: 100
    property real value: minimumValue
    property bool hideWhenFinished: false
    property int barHeight: 4

    height: barHeight

    onValueChanged: {
        if(hideWhenFinished) {
            if(value === maximumValue) {
                height = 0;
                visible = false;
            }
            else {
                height = barHeight;
                visible = true;
            }
        }
    }

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
