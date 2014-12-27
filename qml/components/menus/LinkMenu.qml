import QtQuick 2.0
import Sailfish.Silica 1.0

PopupMenu
{
    property string url;
    property bool favorite: false
    property bool isimage: false

    signal openLinkRequested(string url)
    signal openTabRequested(string url)
    signal addToFavoritesRequested(string url)
    signal removeFromFavoritesRequested(string url)

    id: linkmenu
    titleVisible: true
    anchors.fill: parent

    onUrlChanged: {
        favorite = mainwindow.settings.favorites.contains(linkmenu.url);
        title = url;
    }

    popupModel: [ qsTr("Open"),
                  qsTr("Open New Tab"),
                  qsTr("Copy Link"),
                  isimage ? qsTr("Save Image") : qsTr("Save Link Destination"),
                  linkmenu.favorite ? qsTr("Remove From Favorites") : qsTr("Add To Favorites"),]

    popupDelegate: ListItem {
        width: parent.width

        Label {
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: linkmenu.popupModel[index]
        }

        onClicked: {
            linkmenu.hide();

            if(index === 0)
                linkmenu.openLinkRequested(linkmenu.url);
            else if(index === 1)
                linkmenu.openTabRequested(linkmenu.url);
            else if(index === 2)
                Clipboard.text = linkmenu.url;
            else if(index === 3) {
                tabviewremorse.execute(isimage ? qsTr("Downloading image") : qsTr("Downloading link"), function() {
                    mainwindow.settings.downloadmanager.createDownload(linkmenu.url);
                });
            }
            else if(index === 4)
            {
                if(linkmenu.favorite)
                    linkmenu.addToFavoritesRequested(linkmenu.url);
                else
                    linkmenu.removeFromFavoritesRequested(linkmenu.url);
            }
        }
    }
}
