import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property bool startHandle: false
    property alias moving: mousearea.pressed

    id: selectorhandle
    radius: width * 0.5

    MouseArea
    {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: {
            if(mouse.button !== Qt.LeftButton)
                return;

            var mappedpoint = mapToItem(webView, mouse.x, mouse.y);

            var touchdata = { "start": startHandle,
                              "x": mappedpoint.x / webView.contentsScale,
                              "y": mappedpoint.y / webView.contentsScale };

            webView.postMessage("textselectorhandler_updateselection", { "touchdata": touchdata });
        }
    }
}

