import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"

Dialog
{
    property Settings settings
    property var cookieItem

    id: dlgbookmark
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader
            {
                id: dlgheader
                acceptText: qsTr("Save")
            }

            TextField
            {
                width: parent.width
                label: qsTr("Name")
                placeholderText: label
                text: cookieItem.name
            }

            TextField
            {
                width: parent.width
                label: qsTr("Domain")
                placeholderText: label
                text: cookieItem.domain
            }

            TextField
            {
                width: parent.width
                label: qsTr("Path")
                placeholderText: label
                text: cookieItem.path
            }

            TextField
            {
                width: parent.width
                label: qsTr("Expires")
                placeholderText: label
                text: cookieItem.expires
            }

            TextArea
            {
                width: parent.width
                label: qsTr("Value")
                placeholderText: label
                text: cookieItem.value
            }
        }
    }
}
