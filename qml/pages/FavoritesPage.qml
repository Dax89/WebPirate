import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../components/tabview"
import "../models"

Dialog
{
    property Settings settings
    property TabView tabview

    id: favoritesdialog
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop

    PageHeader {
        id: header
        title: qsTr("Favorites")
    }

    FavoritesView
    {
        id: favoritesview
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        onUrlRequested: {
            tabview.pages.get(tabview.currentIndex).tab.load(favoriteurl);
            favoritesdialog.accept();
        }
    }
}
