import QtQuick 2.1
import Sailfish.Silica 1.0
import "../dialogs"

PopupDialog
{
    property bool manageNavigationBar: true

    QtObject
    {
        property bool navigationWasVisible: true
        id: webviewdialogprivate
    }

    id: webviewdialog
    width: Screen.width
    height: Screen.height - tabheader.height

    onVisibleChanged: {
        if(!manageNavigationBar)
            return;

        if(visible) {
            webviewdialogprivate.navigationWasVisible = navigationbar.visible;
            navigationbar.evaporate();
            return;
        }

        navigationbar.solidify();
    }

    Component.onCompleted: show()

    Component.onDestruction: {
        if(manageNavigationBar && webviewdialogprivate.navigationWasVisible)
            navigationbar.solidify();
    }
}
