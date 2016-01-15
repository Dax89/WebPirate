import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../js/UrlHelper.js" as UrlHelper

Dialog
{
    property FavoritesModel model
    property int favoriteId: -1
    property int parentId
    property bool isFolder
    property alias title: tftitle.text
    property alias url: tfurl.text

    id: dlgbookmark
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: false

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

            onTextChanged: {
                dlgbookmark.canAccept = text.length > 0;
            }
        }

        TextField
        {
            id: tfurl
            placeholderText: qsTr("Url")
            visible: !isFolder
            anchors { left: parent.left; right: parent.right }
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
    }

    onDone: {
        if(result === DialogResult.Accepted)
        {
            if(favoriteId !== -1)
            {
                if(isFolder)
                    model.replaceFolder(dlgbookmark.favoriteId, model.currentId, tftitle.text);
                else
                    model.replaceUrl(dlgbookmark.favoriteId, model.currentId, tftitle.text, UrlHelper.adjustUrl(tfurl.text));
            }
            else if(isFolder)
                model.addFolder(tftitle.text, dlgbookmark.parentId);
            else
                model.addUrl(tftitle.text, UrlHelper.adjustUrl(tfurl.text), dlgbookmark.parentId);
        }
    }
}
