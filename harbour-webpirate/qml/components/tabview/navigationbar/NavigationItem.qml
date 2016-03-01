import QtQuick 2.1
import Sailfish.Silica 1.0

BackgroundItem
{
    property alias source: img.source

    id: navigationitem

    Image
    {
        id: img
        anchors.fill: parent
    }
}
