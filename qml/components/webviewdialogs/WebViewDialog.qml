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

    Component.onCompleted: {
        if(manageNavigationBar) {
            webviewdialogprivate.navigationWasVisible = navigationbar.visible;
            navigationbar.evaporate();
        }

        show();
    }

    Component.onDestruction: {
        if(manageNavigationBar && webviewdialogprivate.navigationWasVisible)
            navigationbar.solidify();
    }
}
