import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components/menus"
import "../models"
import "../js/UrlHelper.js" as UrlHelper

Dialog
{
    property alias title: tftitle.text
    property alias url: tfurl.text

    property Settings settings
    property int index

    id: quickgridpage

    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: (tftitle.text.length > 0) && (tfurl.text.length > 0)

    Column
    {
        anchors.fill: parent

        DialogHeader {
            acceptText: qsTr("Save")
        }

        TextField
        {
            id: tftitle
            placeholderText: qsTr("Title")
            anchors { left: parent.left; right: parent.right }
        }

        TextField
        {
            id: tfurl
            placeholderText: qsTr("Url")
            anchors { left: parent.left; right: parent.right }
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
    }

    onAccepted: settings.quickgridmodel.replace(quickgridpage.index, tftitle.text, UrlHelper.adjustUrl(tfurl.text))
}
