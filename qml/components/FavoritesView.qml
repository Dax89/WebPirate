import QtQuick 2.0
import Sailfish.Silica 1.0
import "../models"
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites

Item
{
    property alias model: favoritesmodel
    signal urlRequested(string favoriteurl)

    SilicaListView
    {
        id: favoritesview
        clip: true
        anchors.fill: parent
        model: FavoritesModel { id: favoritesmodel }

        delegate: ListItem {
            id: listitem
            contentHeight: Theme.itemSizeSmall
            width: favoritesview.width

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Edit");

                    onClicked: pageStack.push(Qt.resolvedUrl("../pages/FavoritePage.qml"), {"model": favoritesmodel,
                                                                                            "favoriteId": favoriteid,
                                                                                            "parentId": parentid,
                                                                                            "isFolder": isfolder,
                                                                                            "title": title,
                                                                                            "url": url });
                }

                MenuItem {
                    text: qsTr("Delete");

                    onClicked: listitem.remorseAction(qsTr("Deleting Favorite"),
                                                      function() {
                                                          favoritesmodel.erase(favoriteid, parentid);
                                                      });
                }
            }

            onClicked: {
                if(isfolder) {
                    pageStack.push(Qt.resolvedUrl("../pages/FavoritesPage.qml"), { "folderId": favoriteid, "tabview": tabview, "rootPage": rootPage })
                    return;
                }

                urlRequested(url);
                pageStack.pop(rootPage);
            }

            Row {
                anchors.fill: parent
                spacing: Theme.paddingSmall

                Image
                {
                    id: favicon
                    cache: false
                    asynchronous: true
                    width: Theme.iconSizeSmall
                    height: Theme.iconSizeSmall
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    source: isfolder ? "image://theme/icon-m-folder" : mainwindow.settings.icondatabase.provideIcon(url)
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
}
