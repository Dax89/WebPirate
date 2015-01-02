import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/tabview"
import "../models"

Page
{
    property int folderId
    property TabView tabview
    property Page rootPage

    id: favoritespage
    allowedOrientations: Orientation.All

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Add Folder")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/FavoritePage.qml"), { "model": favoritesview.model, "isFolder": true, "parentId": favoritesview.model.currentId });
            }

            MenuItem
            {
                text: qsTr("Add Favorite")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/FavoritePage.qml"), { "model": favoritesview.model, "isFolder": false, "parentId": favoritesview.model.currentId });
            }
        }

        PageHeader { id: header }

        FavoritesView
        {
            id: favoritesview
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

            onUrlRequested: {
                tabview.pages.get(tabview.currentIndex).tab.load(favoriteurl);
            }
        }
    }

    Component.onCompleted: {
        favoritesview.model.jumpTo(folderId);
        header.title = (folderId === 0 ? qsTr("Favorites") : favoritesview.model.currentFolder());
    }
}
