import QtQuick 2.0
import Sailfish.Silica 1.0
import "../models"
import "../js/Database.js" as Database
import "../js/Favorites.js" as Favorites

Item
{
    signal urlRequested(string favoriteurl)

    function needsBackButtun()
    {
        if(favoritesmodel.currentId === 0)
        {
            lblfolder.text = qsTr("Favorites");
            btnback.visible = false;
            return;
        }

        lblfolder.text = favoritesmodel.currentFolder();
        btnback.visible = true;
    }

    Component.onCompleted: needsBackButtun()

    Rectangle
    {
        id: header
        anchors { left: parent.left; top: parent.top; right: parent.right }
        color: Theme.highlightDimmerColor
        height: Theme.iconSizeMedium

        IconButton
        {
            id: btnback
            height: Theme.iconSizeMedium
            width: visible ? Theme.iconSizeMedium : 0
            anchors { left: parent.left; verticalCenter: lblfolder.verticalCenter; rightMargin: Theme.paddingLarge }
            icon.source: "image://theme/icon-m-back"
            onClicked: favoritesmodel.jumpBack()
        }

        Label
        {
            id: lblfolder
            anchors { left: btnback.right; right: parent.right; verticalCenter: parent.verticalCenter }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Favorites")
            elide: Text.ElideRight
            clip: true
        }
    }

    SilicaListView
    {
        id: favoritesview
        clip: true
        anchors { left: parent.left; top: header.bottom; right: parent.right; bottom: parent.bottom }

        model: FavoritesModel {
            id: favoritesmodel

            onCurrentIdChanged: needsBackButtun();
        }

        delegate: ListItem {
            id: listitem
            contentHeight: Theme.itemSizeSmall
            width: favoritesview.width

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Edit");

                    onClicked: pageStack.push(Qt.resolvedUrl("../pages/FavoritePage.qml"), {"settings": mainwindow.settings,
                                                                                            "favoriteId": favoriteid,
                                                                                            "parentId": parentid,
                                                                                            "isFolder": isfolder,
                                                                                            "title": title,
                                                                                            "url": url });
                }

                MenuItem {
                    text: qsTr("Delete");

                    onClicked: listitem.remorseAction(qsTr("Deleting Bookmark"),
                                                      function() {
                                                          Favorites.remove(id);
                                                      });
                }
            }

            onClicked: {
                if(isfolder)
                {
                    favoritesmodel.jumpTo(favoriteid);
                    return;
                }

                urlRequested(url);
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
