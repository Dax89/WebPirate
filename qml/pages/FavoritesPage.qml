import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/tabview"
import "../models"

Dialog
{
    property TabView tabview

    id: favoritesdialog
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop

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

        PageHeader
        {
            id: header
            title: qsTr("Favorites")
        }

        FavoritesView
        {
            id: favoritesview
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }

            onUrlRequested: {
                tabview.pages.get(tabview.currentIndex).tab.load(favoriteurl);
                favoritesdialog.accept();
            }
        }
    }
}
