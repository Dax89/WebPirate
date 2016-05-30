import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0

Rectangle
{
    property bool startHandle: false

    id: selectorhandle
    color: Theme.rgba(Theme.secondaryHighlightColor, 1.0)
    parent: webView
    width: handleSize
    height: width
    radius: width * 0.5
    smooth: true
    visible: false
}

