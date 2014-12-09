import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Settings.js" as Settings

Item
{
    signal backRequested()
    signal refreshRequested()
    signal stopRequested()
    signal forwardRequested()
    signal searchRequested(string searchquery)

    property alias searchBar: searchbar
    property alias backButton: btnback
    property alias forwardButton: btnforward

    id: navigationbar
    height: 60
    state: "loaded";

    states: [ State { name: "loaded"; PropertyChanges { target: btnrefresh; icon.source: "image://theme/icon-m-refresh" } },
              State { name: "loading"; PropertyChanges { target: btnrefresh; icon.source: "image://theme/icon-m-reset" } } ]

    IconButton
    {
        id: btnback
        icon.source: "image://theme/icon-m-back"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors.verticalCenter: navigationbar.verticalCenter
        anchors.left: navigationbar.left
        enabled: false

        onClicked: backRequested();
    }

    IconButton
    {
        id: btnhome
        icon.source: "image://theme/icon-m-home"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors.verticalCenter: navigationbar.verticalCenter
        anchors.left: btnback.right

        onClicked: navigationbar.searchRequested(Settings.homepage);
    }

    IconButton
    {
        id: btnbookmark
        icon.source: "image://theme/icon-m-favorite"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors.verticalCenter: navigationbar.verticalCenter
        anchors.left: btnhome.right
    }

    SearchBar
    {
        id: searchbar
        anchors.left: btnbookmark.right
        anchors.right: btnrefresh.left

        onReturnPressed: navigationbar.searchRequested(searchquery);
    }

    IconButton
    {
        id: btnrefresh
        icon.source: "image://theme/icon-m-refresh"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors.verticalCenter: navigationbar.verticalCenter
        anchors.right: btnforward.left

        onClicked: {
            if(state === "loaded")
                refreshRequested();
            else if(state === "loading")
                stopRequested();
        }
    }

    IconButton
    {
        id: btnforward
        icon.source: "image://theme/icon-m-forward"
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors.verticalCenter: navigationbar.verticalCenter
        anchors.right: navigationbar.right
        enabled: false

        onClicked: forwardRequested();
    }
}
