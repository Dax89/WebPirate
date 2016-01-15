import QtQuick 2.1
import Sailfish.Silica 1.0
import "../models"
import "../js/settings/Database.js" as Database
import "../js/settings/Favorites.js" as Favorites

SilicaListView
{
    signal urlRequested(string favoriteurl, bool newtab)

    VerticalScrollDecorator { flickable: favoritesview }

    BusyIndicator {
        id: busyindicator
        anchors.centerIn: parent
        running: favoritesmodel.busy

        size: BusyIndicatorSize.Large
    }

    id: favoritesview
    model: FavoritesModel { id: favoritesmodel }
    quickScroll: true

    delegate: ListItem {
        id: listitem
        contentHeight: Theme.itemSizeSmall
        contentWidth: favoritesview.width

        menu: ContextMenu {
            MenuItem {
                text: qsTr("Open")
                visible: !isfolder

                onClicked: {
                    urlRequested(url, false)
                    pageStack.pop(rootPage);
                }
            }

            MenuItem {
                text: qsTr("Open in New Tab")
                visible: !isfolder

                onClicked: {
                    urlRequested(url, true)
                    pageStack.pop(rootPage);
                }
            }

            MenuItem {
                text: qsTr("Edit");

                onClicked: pageStack.push(Qt.resolvedUrl("../pages/favorite/FavoritePage.qml"), { "model": favoritesmodel,
                                                                                                  "favoriteId": favoriteid,
                                                                                                  "parentId": parentid,
                                                                                                  "isFolder": isfolder,
                                                                                                  "title": title,
                                                                                                  "url": url });
            }

            MenuItem {
                text: qsTr("Delete");

                onClicked: listitem.remorseAction(isfolder ? qsTr("Deleting Folder") : qsTr("Deleting Favorite"),
                                                  function() {
                                                      favoritesmodel.erase(favoriteid, parentid);
                                                  });
            }

            MenuItem
            {
                text: qsTr("Add to Quick Grid")
                onClicked: mainwindow.settings.quickgridmodel.addUrl(title, url)
            }
        }

        onClicked: {
            if(isfolder) {
                pageStack.push(Qt.resolvedUrl("../pages/favorite/FavoritesPage.qml"), { "folderId": favoriteid, "tabview": tabview, "rootPage": rootPage })
                return;
            }

            urlRequested(url, true);
            pageStack.pop(rootPage);
        }

        Row {
            anchors.fill: parent
            spacing: Theme.paddingMedium

            Image
            {
                id: favicon
                cache: false
                asynchronous: true
                width: Theme.iconSizeSmall
                height: Theme.iconSizeSmall
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter

                source: {
                    if(isfolder)
                        return "image://theme/icon-m-folder";

                    return mainwindow.settings.icondatabase.provideIcon(url);
                }

                onStatusChanged: {
                    if((status !== Image.Error) || isfolder)
                        return;

                   source = "image://theme/icon-m-favorite-selected";
                }
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
