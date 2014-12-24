import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../models"

Dialog
{
    property Settings settings
    property TabView tabview

    id: favoritesdialog
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop

    FavoritesView
    {
        id: favoritesview
        anchors.fill: parent

        onUrlRequested: {
            tabview.pages.get(tabview.currentIndex).tab.load(favoriteurl);
            favoritesdialog.accept();
        }
    }
}
