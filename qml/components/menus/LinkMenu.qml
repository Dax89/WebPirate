import QtQuick 2.0
import Sailfish.Silica 1.0

PopupMenu
{
    property string url;
    property bool favorite: false

    signal openLinkRequested(string url)
    signal openTabRequested(string url)
    signal addToFavoritesRequested(string url)
    signal removeFromFavoritesRequested(string url)

    id: linkmenu
    titleVisible: true

    onUrlChanged: {
        favorite = mainwindow.settings.favorites.contains(linkmenu.url);
        title = url;
    }

    popupModel: [ qsTr("Open Link"),
                  qsTr("Open New Tab"),
                  linkmenu.favorite ? qsTr("Remove From Favorites") : qsTr("Add To Favorites") ]

    popupDelegate: ListItem {
        width: parent.width
        height: Theme.itemSizeSmall

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
            {
                if(linkmenu.favorite)
                    linkmenu.addToFavoritesRequested(linkmenu.url);
                else
                    linkmenu.removeFromFavoritesRequested(linkmenu.url);
            }
        }
    }
}
