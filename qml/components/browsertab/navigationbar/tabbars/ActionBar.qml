import QtQuick 2.1
import Sailfish.Silica 1.0
import ".."
import "../../../../js/settings/Favorites.js" as Favorites
import "../../../../models"

BrowserBar
{
    property bool favorite: false
    property BlockedPopupModel blockedPopups: BlockedPopupModel { }

    signal quickGridRequested()
    signal homepageRequested()
    signal findRequested()

    function calcButtonWidth()
    {
        var count = 4;

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
            id: btnquickgrid
            icon.source: "qrc:///res/quickgrid.png"
            anchors.verticalCenter: parent.verticalCenter
            width: calcButtonWidth()
            height: parent.height

            onClicked: {
                quickGridRequested();
                actionbar.evaporate();
            }
        }

        IconButton
        {
            id: btnhome
            icon.source: "image://theme/icon-m-home"
            anchors.verticalCenter: parent.verticalCenter
            width: calcButtonWidth()
            height: parent.height

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
            height: parent.height

            onClicked: {
                findRequested();
                actionbar.evaporate();
            }
        }

        IconButton
        {
            id: btnfavorite
            visible: navigationbar.queryBar.url.length > 0
            width: visible ? calcButtonWidth() : 0
            height: parent.height
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
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            icon.source: "image://theme/icon-m-tabs"

            onClicked: {
                actionbar.evaporate();
                pageStack.push(Qt.resolvedUrl("../../../../pages/popupblocker/PopupBlockerPage.qml"), { "popupModel": blockedPopups, "tabView": tabview });
            }

            Label
            {
                text: blockedPopups.count
                anchors.fill: parent
                enabled: parent.enabled
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                font.bold: true
            }
        }
    }
}
