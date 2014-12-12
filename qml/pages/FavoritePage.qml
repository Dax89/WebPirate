import QtQuick 2.0
import Sailfish.Silica 1.0
import "../models"
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites

Dialog
{
    property Settings settings
    property int index
    property alias title: tftitle.text
    property alias url: tfurl.text

    id: dlgbookmark
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    Column
    {
        anchors.fill: parent

        DialogHeader {
            title: qsTr("Save")
        }

        TextField
        {
            id: tftitle
            label: qsTr("Title")
            width: parent.width
        }

        TextField
        {
            id: tfurl
            label: qsTr("Url")
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
    }

    onDone: {
        if(result === DialogResult.Accepted)
            Favorites.replace(Database.instance(), settings.favorites, dlgbookmark.index, tftitle.text, tfurl.text);
    }
}
