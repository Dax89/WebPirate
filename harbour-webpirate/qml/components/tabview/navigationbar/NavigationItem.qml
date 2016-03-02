import QtQuick 2.1
import Sailfish.Silica 1.0

BackgroundItem
{
    property string source

    id: navigationitem

    Image
    {
        id: img
        anchors.centerIn: parent
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        opacity: navigationitem.enabled ? 1.0 : 0.4

        source: {
            if(navigationitem.pressed)
                return navigationitem.source + "?" + Theme.highlightColor;

            return navigationitem.source;
        }
    }
}
