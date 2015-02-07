import QtQuick 2.0
import Sailfish.Silica 1.0
import WebPirate.AdBlock 1.0
import "../../models"

Dialog
{
    property Settings settings
    property var adblockreader

    function editRule(index) {
        pageStack.push(Qt.resolvedUrl("AdBlockFilter.qml"), { "index": index, "adblockeditor": adblockeditor });
    }

    id: adblockpage
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    onDone: adblockeditor.saveFilters(settings.adblockmanager)

    AdBlockEditor
    {
        id: adblockeditor
        Component.onCompleted: adblockeditor.loadFilters(settings.adblockmanager)
    }

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Update Filters")
            }

            MenuItem
            {
                text: qsTr("Add Filter")
                onClicked: pageStack.push(Qt.resolvedUrl("AdBlockFilter.qml"), { "adblockeditor": adblockeditor });
            }
        }

        DialogHeader
        {
            id: dlgheader;
            acceptText: qsTr("Save")
        }

        SilicaListView
        {
            id: listview
            anchors { left: parent.left; top: dlgheader.bottom; right: parent.right; bottom: parent.bottom }
            model: adblockeditor.filtersCount

            delegate: ListItem {
                id: listitem
                contentWidth: parent.width
                contentHeight: Theme.itemSizeSmall
                onClicked: editRule(index)

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Edit")
                        onClicked: editRule(index)
                    }

                    MenuItem {
                        text: qsTr("Delete")
                        onClicked: listitem.remorseAction(qsTr("Deleting filter"),
                                                          function() {
                                                              adblockeditor.deleteFilter(index);
                                                          });
                    }
                }

                Label
                {
                    anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                    verticalAlignment: Text.AlignVCenter
                    text: adblockeditor.filter(index)
                }
            }
        }
    }
}
