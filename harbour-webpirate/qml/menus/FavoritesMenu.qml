import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/settings/Favorites.js" as Favorites

PullDownMenu
{
    MenuItem
    {
        text: qsTr("Export") + ((folderId === 0) ? "" : " '" + favoritesview.model.currentFolder() + "'")

        onClicked: {
            remorsepopup.execute(qsTr("Exporting favorites"), function() {
                Favorites.doExport(favoritesmanager, folderId, (folderId === 0) ? qsTr("Favorites") : favoritesmodel.currentFolder());
                favoritesmanager.clearTree();
                popupmessage.show(qsTr("Favorites exported successfully"))
            });
        }
    }

    MenuItem
    {
        text: (folderId === 0) ? qsTr("Import") : (qsTr("Import in") + " '" + favoritesmodel.currentFolder() + "'")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/segment/favorite/FavoritesImportPage.qml"), { "returnPage": pageStack.currentPage, "favoritesManager": favoritesmanager });
    }

    MenuItem
    {
        text: qsTr("Add Folder")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/segment/favorite/FavoritePage.qml"), { "model": favoritesmodel, "isFolder": true, "parentId": favoritesmodel.currentId });
    }

    MenuItem
    {
        text: qsTr("Add Favorite")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/segment/favorite/FavoritePage.qml"), { "model": favoritesmodel, "isFolder": false, "parentId": favoritesmodel.currentId });
    }
}
