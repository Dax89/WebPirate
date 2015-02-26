import QtQuick 2.1
import Sailfish.Silica 1.0
import "tabbars"
import "../../../js/Favorites.js" as Favorites
import "../../../js/UrlHelper.js" as UrlHelper

BrowserBar
{
    signal backRequested()
    signal actionBarRequested()
    signal refreshRequested()
    signal stopRequested()
    signal forwardRequested()
    signal searchRequested(string searchquery)

    property alias queryBar: querybar
    property alias actionButton: btnaction
    property alias backButton: btnback
    property alias forwardButton: btnforward


    id: navigationbar
    state: "loaded";
    opacity: 1.0

    states: [ State { name: "loaded"; PropertyChanges { target: btnrefresh; icon.source: "image://theme/icon-m-refresh" } },
              State { name: "loading"; PropertyChanges { target: btnrefresh; icon.source: "image://theme/icon-m-reset" } } ]

    IconButton
    {
        id: btnback
        icon.source: "image://theme/icon-m-back"
        width: visible ? Theme.iconSizeMedium : 0
        visible: !querybar.editing
        anchors { left: navigationbar.left; top: parent.top; bottom: parent.bottom }
        enabled: false
        onClicked: backRequested();
    }

    IconButton
    {
        id: btnaction
        icon.source: "image://theme/icon-m-levels"
        width: visible ? Theme.iconSizeMedium : 0
        visible: !querybar.editing
        anchors { left: btnback.right; top: parent.top; bottom: parent.bottom }
        enabled: false
        onClicked: actionBarRequested()

        Label
        {
            id: lblalert
            anchors.fill: btnaction.icon
            visible: actionbar.blockedPopups.count > 0
            color: "orangered"
            font.bold: true
            text: "!"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop

            onVisibleChanged: {
                if(visible)
                    gumanimation.start();
            }

            PropertyAnimation { id: gumanimation; target: lblalert; property: "scale"; from: 1.5; to: 1.0; running: false; duration: 200; easing.type: Easing.OutBounce }
        }
    }

    QueryBar
    {
        id: querybar
        anchors { left: btnaction.right; right: btnrefresh.left; verticalCenter: parent.verticalCenter }
        onReturnPressed: navigationbar.searchRequested(searchquery);
    }

    IconButton
    {
        id: btnrefresh
        icon.source: "image://theme/icon-m-refresh"
        width: visible ? Theme.iconSizeMedium : 0
        visible: !querybar.editing
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
        width: visible ? Theme.iconSizeMedium : 0
        visible: !querybar.editing
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
        enabled: false

        onClicked: forwardRequested();
    }
}
