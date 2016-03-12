import QtQuick 2.1
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0
import "../quickgrid"

Item
{
    property alias stack: tabstackitems
    property bool dialogsVisible

    signal hideAll()

    function hideQuickGrid() {
        quickgrid.visible = false;
    }

    function showQuickGrid() {
        quickgrid.disableEditMode();
        quickgrid.visible = true;
    }

    id: tabstack

    QuickGrid
    {
        id: quickgrid
        anchors.fill: parent
        visible: false

        onNewTabRequested: tabview.addTab(mainwindow.settings.homepage)
        onLoadRequested: tabview.currentTab().load(request)
    }

    Item
    {
        id: tabstackitems
        anchors.fill: parent
    }

    MouseArea
    {
        id: hidearea
        anchors.fill: tabstackitems
        visible: dialogsVisible

        onClicked: {
            hideAll();
        }
    }
}
