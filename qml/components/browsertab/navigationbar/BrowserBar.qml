import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    signal solidified()
    signal evaporated()

    function solidify() {
        opacity = 1.0;
        solidified();
    }

    function evaporate() {
        opacity = 0.0;
        evaporated();
    }

    id: browserbar
    opacity: 0.0
    height: opacity > 0.0 ? Theme.iconSizeMedium : 0
    visible: opacity > 0.0 && (Qt.application.state === Qt.ApplicationActive)
    z: 1

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.9) }
    }

    Behavior on opacity {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }
}
