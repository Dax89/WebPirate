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
    canAccept: false

    onCookieItemChanged: {
        dlgbookmark.canAccept = true;

        tfname.text = cookieItem.name;
        tfdomain.text = cookieItem.domain;
        tfpath.text = cookieItem.path;
        tfexpires.text = cookieItem.expires;
        tfvalue.text = cookieItem.value;
    }

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
                id: tfname
                width: parent.width
                label: qsTr("Name")
                placeholderText: label
            }

            TextField
            {
                id: tfdomain
                width: parent.width
                label: qsTr("Domain")
                placeholderText: label
            }

            TextField
            {
                id: tfpath
                width: parent.width
                label: qsTr("Path")
                placeholderText: label
            }

            TextField
            {
                id: tfexpires
                width: parent.width
                label: qsTr("Expires")
                placeholderText: label
            }

            TextArea
            {
                id: tfvalue
                width: parent.width
                label: qsTr("Value")
                placeholderText: label
            }
        }
    }
}
