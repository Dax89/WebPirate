import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../models"

Page
{
    property Settings settings

    id: favoritespage
    allowedOrientations: Orientation.All

    PageHeader
    {
        id: pageheader
        title: qsTr("Favorites")
    }

    FavoritesView
    {
        anchors.top: pageheader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
