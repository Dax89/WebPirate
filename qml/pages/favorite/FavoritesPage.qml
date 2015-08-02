import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.LocalStorage 1.0
import "../../components"
import "../../components/tabview"
import "../../models"
import "../../js/settings/Favorites.js" as Favorites

Page
{
    property int folderId
    property TabView tabview
    property Page rootPage

    id: favoritespage
    allowedOrientations: defaultAllowedOrientations

    RemorsePopup { id: remorsepopup }
    PopupMessage { id: popupmessage; anchors { left: parent.left; top: parent.top; right: parent.right } }

    FavoritesManager
    {
        id: favoritesmanager

        onParsingCompleted: {
            Favorites.doImport(favoritesmanager.root, folderId, favoritesview.model)
            favoritesmanager.clearTree();
            popupmessage.show(qsTr("Favorites imported successfully"))
        }

        onParsingError: popupmessage.show(qsTr("Cannot import favorites"));
    }

    FavoritesView
    {
        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Delete all Favorites")
                visible: folderId === 0

                onClicked: {
                    remorsepopup.execute(qsTr("Deleting all favorites"), function() {
                        favoritesview.model.clear();
                        Favorites.deleteAll();
                    });
                }
            }

            MenuItem
            {
                text: qsTr("Export") + ((folderId === 0) ? "" : " '" + favoritesview.model.currentFolder() + "'")

                onClicked: {
                    remorsepopup.execute(qsTr("Exporting favorites"), function() {
                        Favorites.doExport(favoritesmanager, folderId, (folderId === 0) ? qsTr("Favorites") : favoritesview.model.currentFolder());
                        favoritesmanager.clearTree();
                        popupmessage.show(qsTr("Favorites exported successfully"))
                    });
                }
            }

            MenuItem
            {
                text: (folderId === 0) ? qsTr("Import") : (qsTr("Import in") + " '" + favoritesview.model.currentFolder() + "'")
                onClicked: pageStack.push(Qt.resolvedUrl("FavoritesImportPage.qml"), { "favoritesManager": favoritesmanager, "rootPage": favoritespage });
            }

            MenuItem
            {
                text: qsTr("Add Folder")
                onClicked: pageStack.push(Qt.resolvedUrl("FavoritePage.qml"), { "model": favoritesview.model, "isFolder": true, "parentId": favoritesview.model.currentId });
            }

            MenuItem
            {
                text: qsTr("Add Favorite")
                onClicked: pageStack.push(Qt.resolvedUrl("FavoritePage.qml"), { "model": favoritesview.model, "isFolder": false, "parentId": favoritesview.model.currentId });
            }
        }

        id: favoritesview
        anchors.fill: parent
        header: PageHeader { id: header }

        onUrlRequested: {
            if(newtab)
                tabview.addTab(favoriteurl);
            else
                tabview.tabs.get(tabview.currentIndex).tab.load(favoriteurl);
        }
    }

    onStatusChanged: {
        if(status !== PageStatus.Active)
            return;

        favoritesview.model.jumpTo(folderId);
        favoritesview.headerItem.title = (folderId === 0 ? qsTr("Favorites") : favoritesview.model.currentFolder());
    }
}
