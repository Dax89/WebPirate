import QtQuick 2.0
import Sailfish.Silica 1.0

IconButton
{
    id: btnedit
    width: Theme.iconSizeSmall
    height: Theme.iconSizeSmall
    icon.fillMode: Image.PreserveAspectFit
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }
}
