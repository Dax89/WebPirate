import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites

SilicaListView
{
    signal urlRequested(string favoriteurl)

    id: favoritesview
    clip: true
    model: mainwindow.settings.favorites

    delegate: ListItem {
        id: listitem
        contentHeight: Theme.itemSizeSmall
        width: favoritesview.width

        menu: ContextMenu {
            MenuItem {
                id: miedit
                text: qsTr("Edit");

                onClicked: pageStack.push(Qt.resolvedUrl("../pages/FavoritePage.qml"), {"settings": mainwindow.settings, "index": index, "title": title, "url": url });
            }

            MenuItem {
                id: midelete
                text: qsTr("Delete");

                onClicked: listitem.remorseAction(qsTr("Deleting Bookmark"),
                                                  function() {
                                                      var favoriteurl = mainwindow.settings.favorites.get(index).url;
                                                      Favorites.remove(Database.instance(), mainwindow.settings.favorites, favoriteurl);
                                                  });
            }
        }

        onClicked: urlRequested(url);

        Row {
            anchors.fill: parent
            spacing: Theme.paddingSmall

            Image
            {
                id: favicon
                cache: true
                asynchronous: true
                width: Theme.iconSizeSmall
                height: Theme.iconSizeSmall
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                source: (icon !== "") ? icon : "image://theme/icon-m-favorite"
            }

            Label {
                id: lbltitle;
                height: parent.height
                width: favoritesview.width - favicon.width
                text: title
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                truncationMode: TruncationMode.Fade
                color: listitem.down ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
}
