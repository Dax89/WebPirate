import QtQuick 2.1
import Sailfish.Silica 1.0

ListItem
{
    property alias icon: favicon.source
    property alias title: lbltitle.text

    id: favoriteitem

    menu: ContextMenu {
            MenuItem {
                text: qsTr("Open")
                visible: !model.isfolder

                onClicked: {
                    tabview.currentTab().load(model.url);
                    pageStack.pop();
                }
            }

            MenuItem {
                text: qsTr("Edit");

                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/segment/favorite/FavoritePage.qml"), { "model": favoritesmodel,
                                                                                                             "favoriteId": model.favoriteid,
                                                                                                             "parentId": model.parentid,
                                                                                                             "isFolder": model.isfolder,
                                                                                                             "title": model.title,
                                                                                                             "url": model.url });
            }

            MenuItem {
                text: qsTr("Delete");

                onClicked: favoriteitem.remorseAction(model.isfolder ? qsTr("Deleting Folder") : qsTr("Deleting Favorite"),
                                                  function() {
                                                      favoritesmodel.erase(model.favoriteid, model.parentid);
                                                  });
            }

            MenuItem
            {
                text: qsTr("Add to Quick Grid")
                onClicked: settings.quickgridmodel.addUrl(model.title, model.url)
            }
    }

    Row
    {
        anchors { fill: parent; leftMargin: Theme.paddingMedium }
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

            onStatusChanged: {
                if(status !== Image.Error)
                    return;

                source = "image://theme/icon-m-favorite-selected";
            }
        }

        Label
        {
            id: lbltitle
            height: parent.height
            width: favoriteitem.width - favicon.width - Theme.paddingLarge
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            truncationMode: TruncationMode.Fade
            color: favoriteitem.down ? Theme.highlightColor : Theme.primaryColor
        }
    }
}
