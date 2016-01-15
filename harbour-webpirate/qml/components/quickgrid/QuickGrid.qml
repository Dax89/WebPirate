import QtQuick 2.1
import Sailfish.Silica 1.0
import "../browsertab/navigationbar/tabbars"

Item
{
    property bool editMode: false

    signal loadRequested(string request)

    function enableEditMode()
    {
        if(editMode)
            return;

        editMode = true;
        querybar.animationEnabled = true;
        querybar.visible = false;
        sidebar.collapse();
    }

    function disableEditMode()
    {
        if(!editMode)
            return;

        editMode = false;
        querybar.visible = true;
        querybar.animationEnabled = false;
    }

    id: quickgrid

    QueryBar
    {
        id: querybar
        anchors { left: parent.left; top: parent.top; right: parent.right; topMargin: Theme.paddingLarge; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
        onReturnPressed: loadRequested(searchquery)

        onVisibleChanged: {
            if(!visible)
                querybar.clear();
        }
    }

    SilicaGridView
    {
        property real spacing: mainpage.isPortrait ? Theme.paddingMedium : Theme.paddingLarge

        id: quickgridview
        anchors { left: parent.left; top: querybar.bottom; right: parent.right; bottom: quickgridbottompanel.top; topMargin: Theme.paddingLarge }
        cellWidth: mainpage.isPortrait ? (width / 3) : (width / 4)
        cellHeight: cellWidth
        model: mainwindow.settings.quickgridmodel
        interactive: (mousearea.currentQuickId === -1)
        clip: true

        onVerticalVelocityChanged: sidebar.collapse();

        delegate: QuickGridItem {
            id: quickitem
            itemTitle: title
            itemUrl: url
            itemId: quickId
        }

        VerticalScrollDecorator { flickable: quickgridview }

        ViewPlaceholder
        {
            id: placeholder
            z: -1
            enabled: !editMode && !mainwindow.settings.quickgridmodel.count
            text: qsTr("The Quick Grid is empty") + "\n" + qsTr("Long Press to edit")
        }

        MouseArea
        {
            property int currentQuickId: -1
            property int newIndex
            property int index: quickgridview.indexAt(mousearea.mouseX + quickgridview.contentX, mousearea.mouseY + quickgridview.contentY)

            id: mousearea
            anchors.fill: parent

            onClicked: {
                sidebar.collapse();

                if(editMode) {
                    disableEditMode();
                    return;
                }

                if(index === -1)
                    return;

                var url = mainwindow.settings.quickgridmodel.get(index).url;

                if(url && url.length) {
                    loadRequested(url);
                    sidebar.collapse();
                }
            }

            onPressAndHold: {
                if(editMode) {
                    currentQuickId = mainwindow.settings.quickgridmodel.get(newIndex = index).quickId;
                    return;
                }

                enableEditMode();
            }

            onReleased: {
                currentQuickId = -1;
            }

            onPositionChanged: {
                if((mousearea.currentQuickId !== -1) && (index !== -1) && (index !== newIndex)) {
                    mainwindow.settings.quickgridmodel.move(newIndex, newIndex = index, 1);
                    quickgridview.positionViewAtIndex(newIndex, GridView.Contain);
                }
            }
        }
    }

    QuickGridBottomPanel
    {
        id: quickgridbottompanel
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: editMode && (mousearea.currentQuickId === -1) ? Theme.itemSizeSmall : 0

        onAddRequested: pageStack.push(Qt.resolvedUrl("../../pages/QuickGridPage.qml"), { "settings": mainwindow.settings })
        onDoneRequested: disableEditMode();
    }
}
