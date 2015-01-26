import QtQuick 2.1
import Sailfish.Silica 1.0

IconButton
{
    id: btnedit
    width: quickgriditem.width * 0.25
    height: width
    icon { width: width; height: height; fillMode: Image.PreserveAspectFit }
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }
}
