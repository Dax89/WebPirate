import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/navigationbar"

Rectangle
{
    property bool editMode: false

    function enableEditMode()
    {
        if(editMode)
            return;

        editMode = true;
        sidebar.collapse();
    }

    function disableEditMode()
    {
        if(!editMode)
            return;

        editMode = false;
    }

    id: quickgrid

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.7) }
    }

    Rectangle
    {
        id: coverrectangle
        anchors { left: parent.left; top: parent.top; right: parent.right }
        color: Theme.rgba(Theme.highlightDimmerColor, 1.0)
        height: tabheader.height
    }

    SearchBar
    {
        id: searchbar
        anchors { left: parent.left; top: coverrectangle.bottom; right: parent.right; topMargin: Theme.paddingLarge; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
        onReturnPressed: browsertab.load(searchquery)

        onVisibleChanged: {
            if(!visible)
                searchbar.clear();
        }
    }

    SilicaFlickable
    {
        id: flick
        anchors { left: parent.left; top: searchbar.bottom; right: parent.right; bottom: parent.bottom; topMargin: Theme.paddingLarge }
        contentHeight: mainwindow.settings.quickgridmodel.count > 1 ? quickgriditems.height : parent.height
        onVerticalVelocityChanged: sidebar.collapse();
        clip: true

        VerticalScrollDecorator { flickable: flick }

        ViewPlaceholder
        {
            id: placeholder
            anchors.fill: parent
            enabled: !editMode && (mainwindow.settings.quickgridmodel.count === 1)
            text: qsTr("The QuickGrid is empty")

            MouseArea {
                anchors.fill: parent

                onPressAndHold: {
                    placeholder.enabled = false;
                    enableEditMode();
                }
            }
        }

        Flow
        {
            id: quickgriditems
            visible: (editMode && mainwindow.settings.quickgridmodel.count === 1) || mainwindow.settings.quickgridmodel.count > 1
            anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
            spacing: Theme.paddingMedium

            Repeater
            {
                model: mainwindow.settings.quickgridmodel

                delegate: QuickGridItem {
                    id: quickitem
                    width: (parent.width / 3) - quickgriditems.spacing
                    height: width
                    specialItem: special
                    itemTitle: special ? "" : title
                    itemUrl: special ? "" : url
                    editEnabled: editMode

                    onPressAndHold: enableEditMode();

                    onClicked: {
                        if(special) {
                            mainwindow.settings.quickgridmodel.addEmpty();
                            return;
                        }

                        if(editMode) {
                            disableEditMode();
                            return;
                        }

                        if(url && url.length)
                            browsertab.load(url);

                        sidebar.collapse();
                    }
                }
            }
        }
    }
}
