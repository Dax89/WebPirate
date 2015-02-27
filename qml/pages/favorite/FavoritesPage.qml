import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate 1.0
import "../../components"
import "../../components/tabview"
import "../../models"
import "../../js/Favorites.js" as Favorites

Page
{
    property int folderId
    property TabView tabview
    property Page rootPage

    id: favoritespage
    allowedOrientations: Orientation.All

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
    }

    SilicaFlickable
    {
        anchors.fill: parent

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

                onClicked: {
                    var page = pageStack.push(Qt.resolvedUrl("../picker/FilePickerPage.qml"), { "filter": "*.htm;*.html", "rootPage": favoritespage });

                    page.filePicked.connect(function(file) {
                        favoritesmanager.importFile(file);
                    });
                }
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

        PageHeader { id: header }

        FavoritesView
        {
            id: favoritesview
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

            onUrlRequested: {
                if(newtab)
                    tabview.addTab(favoriteurl);
                else
                    tabview.tabsget(tabview.currentIndex).tab.load(favoriteurl);
            }
        }
    }

    Component.onCompleted: {
        favoritesview.model.jumpTo(folderId);
        header.title = (folderId === 0 ? qsTr("Favorites") : favoritesview.model.currentFolder());
    }
}
