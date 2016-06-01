import QtQuick 2.1
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0

Item
{
    readonly property int padding: 4 * 1.5
    property bool startHandle: false
    property color color: Theme.rgba(Theme.secondaryHighlightColor, 1.0)

    id: selectorhandle
    parent: webView
    width: handleSize
    height: width * 2
    visible: false
    clip: true

    Rectangle
    {
        id: toppart
        anchors { fill: parent; leftMargin: startHandle ? padding : 0; rightMargin: startHandle ? 0 : padding}
        color: selectorhandle.color
        rotation: startHandle ? 45 : -45
    }

    Rectangle
    {
        id: bottompart
        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        height: handleSize
        z: 1

        gradient: Gradient {
            GradientStop { position: 0.0; color: selectorhandle.color }
            GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightColor, 1.0) }
        }
    }
}
