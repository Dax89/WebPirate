import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    property bool busy
    property alias icon: favicon.source

    id: indicator

    BusyIndicator
    {
        id: busyindicator
        visible: busy
        running: busy
        anchors.fill: parent
        size: BusyIndicatorSize.Small
    }

    Image
    {
        id: favicon
        visible: !busy
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        smooth: true
    }
}
