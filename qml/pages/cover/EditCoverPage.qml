import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: dlgeditcover
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    property list<QtObject> covermodel: [ QtObject { readonly property string actionName: qsTr("Go to Previous Tab") },
                                          QtObject { readonly property string actionName: qsTr("Go to Next Tab") },
                                          QtObject { readonly property string actionName: qsTr("Add New Tab") },
                                          QtObject { readonly property string actionName: qsTr("Close Tab") },
                                          QtObject { readonly property string actionName: qsTr("Load Homepage") },
                                          QtObject { readonly property string actionName: qsTr("Close Browser") },
                                          QtObject { readonly property string actionName: qsTr("Wipe personal data") },
                                          QtObject { readonly property string actionName: qsTr("Wipe personal data and exit") } ]

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            DialogHeader { acceptText: qsTr("Save") }

            Repeater
            {
                model: covermodel

                delegate: Item {
                    width: parent.width
                    height: Theme.itemSizeSmall

                    Label {
                        anchors { left: parent.left; top: parent.top; right: lswitch.left; bottom: parent.bottom; }
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: Theme.fontSizeSmall
                        text: actionName
                        elide: Text.ElideRight
                        clip: true
                    }

                    Switch
                    {
                        id: lswitch
                        anchors { top: parent.top; right: rswitch.left; bottom: parent.bottom }
                    }

                    Switch
                    {
                        id: rswitch
                        anchors { top: parent.top; right: parent.right; bottom: parent.bottom }
                    }
                }
            }
        }
    }
}
