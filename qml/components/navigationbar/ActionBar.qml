import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/Favorites.js" as Favorites
import "../../models"

BrowserBar
{
    property bool favorite: false
    property BlockedPopupModel blockedPopups: BlockedPopupModel { }

    signal homepageRequested()
    signal findRequested()

    function calcButtonWidth()
    {
        var count = 3;

        if(btnfavorite.visible)
            count++;

        return row.width / count;
    }

    id: actionbar

    Row
    {
        id: row
        anchors.fill: parent

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
            visible: navigationbar.searchBar.url.length > 0
            width: visible ? calcButtonWidth() : 0
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

        IconButton
        {
            id: btnpopups
            enabled: blockedPopups.count > 0
            width: visible ? calcButtonWidth() : 0
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-tabs"

            onClicked: {
                actionbar.evaporate();
                pageStack.push(Qt.resolvedUrl("../../pages/popupblocker/PopupBlockerPage.qml"), { "popupModel": blockedPopups, "tabView": tabview });
            }

            Label
            {
                text: blockedPopups.count
                x: btnpopups.icon.x + (btnpopups.icon.width - contentWidth) / 2 - (contentWidth / 2)
                y: btnpopups.icon.y + (btnpopups.icon.height - contentHeight) / 2 - (contentHeight / 5)
                color: Theme.highlightDimmerColor
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                font.bold: true
            }
        }
    }
}
