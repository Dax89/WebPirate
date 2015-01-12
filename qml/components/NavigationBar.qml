import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites
import "../js/UrlHelper.js" as UrlHelper

Rectangle
{
    signal backRequested()
    signal refreshRequested()
    signal stopRequested()
    signal forwardRequested()
    signal searchRequested(string searchquery)

    property bool favorite: false

    property alias searchBar: searchbar
    property alias backButton: btnback
    property alias forwardButton: btnforward

    function expand() {
        height = Theme.iconSizeMedium
    }

    function collapse() {
        height = 0;
    }

    id: navigationbar
    height: Theme.iconSizeMedium
    visible: height > 0
    state: "loaded";
    z: 1

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.9) }
    }

    states: [ State { name: "loaded"; PropertyChanges { target: btnrefresh; icon.source: "image://theme/icon-m-refresh" } },
              State { name: "loading"; PropertyChanges { target: btnrefresh; icon.source: "image://theme/icon-m-reset" } } ]

    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    IconButton
    {
        id: btnback
        icon.source: "image://theme/icon-m-back"
        width: Theme.iconSizeMedium
        anchors { left: navigationbar.left; top: parent.top; bottom: parent.bottom }
        enabled: false

        onClicked: backRequested();
    }

    IconButton
    {
        id: btnhome
        icon.source: "image://theme/icon-m-home"
        width: Theme.iconSizeMedium
        anchors { left: btnback.right; top: parent.top; bottom: parent.bottom }

        onClicked: navigationbar.searchRequested(mainwindow.settings.homepage)
    }

    IconButton
    {
        id: btnfavorite
        width: visible ? Theme.iconSizeMedium : 0
        icon.source: (favorite ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite")
        anchors { left: btnhome.right; top: parent.top; bottom: parent.bottom }

        onClicked: {
            if(!favorite) {
                Favorites.addUrl(webview.title, webview.url.toString(), 0);
                navigationbar.favorite = true;
            }
            else {
                Favorites.removeFromUrl(webview.url.toString());
                navigationbar.favorite = false;
            }
        }
    }

    SearchBar
    {
        id: searchbar
        anchors { left: btnfavorite.right; right: btnrefresh.left; verticalCenter: parent.verticalCenter }
        onReturnPressed: navigationbar.searchRequested(searchquery);

        onUrlChanged: {
            btnfavorite.visible = (searchbar.url.length == 0) || !UrlHelper.isSpecialUrl(searchbar.url);
        }
    }

    IconButton
    {
        id: btnrefresh
        icon.source: "image://theme/icon-m-refresh"
        width: Theme.iconSizeMedium
        anchors { right: btnforward.left; top: parent.top; bottom: parent.bottom }

        onClicked: {
            if(navigationbar.state === "loaded")
                refreshRequested();
            else if(navigationbar.state === "loading")
                stopRequested();
        }
    }

    IconButton
    {
        id: btnforward
        icon.source: "image://theme/icon-m-forward"
        width: Theme.iconSizeMedium
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
        enabled: false

        onClicked: forwardRequested();
    }
}
