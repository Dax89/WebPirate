import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Rectangle
{
    property bool editMode: false

    id: quickgrid

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.7) }
    }

    SearchBar
    {
        id: searchbar
        anchors { left: parent.left; top: parent.top; right: parent.right; topMargin: Theme.paddingLarge; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
        onReturnPressed: browsertab.load(searchquery)

        onVisibleChanged: {
            if(!visible)
                searchbar.clear();
        }
    }

    Item
    {
        anchors { left: parent.left; top: searchbar.bottom; right: parent.right; bottom: parent.bottom; topMargin: Theme.paddingLarge; leftMargin: Theme.paddingMedium }

        SilicaGridView
        {
            id: gridview
            anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
            width: parent.width
            cellWidth: width / 3
            cellHeight: cellWidth
            model: mainwindow.settings.quickgridmodel
            clip: true

            delegate: ListItem {
                contentWidth: gridview.cellWidth - Theme.paddingLarge
                contentHeight: gridview.cellHeight - Theme.paddingLarge

                QuickGridItem {
                    anchors.fill: parent
                    itemTitle: title
                    itemUrl: url
                    canEdit: editMode
                }

                onPressAndHold: {
                    if(!editMode) {
                        editMode = true;
                        sidebar.collapse();
                    }
                }

                onClicked: {
                    if(editMode) {
                        editMode = false;
                        return;
                    }

                    if(url.length)
                        browsertab.load(url);

                    sidebar.collapse();
                }
            }

            onVerticalVelocityChanged: sidebar.collapse();

            VerticalScrollDecorator { flickable: gridview }
        }
    }
}
