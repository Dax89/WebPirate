import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components"
import "../../models"

Item
{
    id: sidebar
    visible: false
    width: visible ? (mainpage.isPortrait ? parent.width * 0.55 : parent.height * 0.80) : 0
    z: 20

    function expand() {
        visible = true;
        tabheader.solidify();
    }

    function collapse() {
        visible = false;
    }

    Behavior on width {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    PanelBackground
    {
        z: -1
        rotation: -90
        anchors.centerIn: parent
        transformOrigin: Item.Center
        width: parent.height
        height: parent.width
    }

    SilicaListView
    {
        id: lvsidebar
        anchors.fill: parent
        model: SidebarModel { id: sidebarmodel }

        VerticalScrollDecorator { flickable: lvsidebar }

        GestureArea
        {
            property Item item: lvsidebar.itemAt(mouseX, mouseY)

            id: gesturearea
            anchors.fill: parent

            onSwypeRight: sidebar.collapse()

            onClicked: {
                if(gesturearea.gestureRunning || !item)
                    return;

                item.execute();
            }
        }
    }
}
