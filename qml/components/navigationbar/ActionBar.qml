import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/Favorites.js" as Favorites

BrowserBar
{
    property bool favorite: false

    signal homepageRequested()
    signal findRequested()

    function calcButtonWidth()
    {
        var count = 1;

        if(btnfind.visible)
            count++;

        if(btnfavorite.visible)
            count++;

        return row.width / count;
    }

    id: actionbar

    Row
    {
        id: row
        anchors.fill: parent
        spacing: Theme.paddingMedium

        IconButton
        {
            id: btnhome
            icon.source: "image://theme/icon-m-home"
            anchors.verticalCenter: parent.verticalCenter
            width: calcButtonWidth()

            onClicked: {
                homepageRequested();
                actionbar.evaporate();
            }
        }

        IconButton
        {
            id: btnfind
            icon.source: "image://theme/icon-m-search"
            visible: !UrlHelper.isSpecialUrl(navigationbar.searchBar.url)
            anchors.verticalCenter: parent.verticalCenter
            width: calcButtonWidth()

            onClicked: {
                findRequested();
                actionbar.evaporate();
            }
        }

        IconButton
        {
            id: btnfavorite
            width: visible ? calcButtonWidth() : 0
            visible: (navigationbar.searchBar.url.length === 0) || !UrlHelper.isSpecialUrl(navigationbar.searchBar.url)
            anchors.verticalCenter: parent.verticalCenter
            icon.source: (actionbar.favorite ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite")

            onClicked: {
                if(!favorite) {
                    Favorites.addUrl(webview.title, webview.url.toString(), 0);
                    actionbar.favorite = true;
                }
                else {
                    Favorites.removeFromUrl(webview.url.toString());
                    actionbar.favorite = false;
                }
            }
        }
    }
}
