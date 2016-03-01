import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.LocalStorage 1.0
import "../items"
import "../../menus"
import "../../models"
import "../../js/settings/Database.js" as Database
import "../../js/settings/Favorites.js" as Favorites

SilicaListView
{
    property int folderId: 0 // Root folder by default

    function load() {
        favoritesmodel.jumpTo(folderId);
    }

    function unload() { }

    RemorsePopup { id: remorsepopup }
    VerticalScrollDecorator { flickable: favoritessegment }
    FavoritesMenu { id: favoritesmenu }

    BusyIndicator
    {
        id: busyindicator
        anchors.centerIn: parent
        running: favoritesmodel.busy
        size: BusyIndicatorSize.Large
    }

    FavoritesManager
    {
        id: favoritesmanager

        onParsingCompleted: {
            Favorites.doImport(favoritesmanager.root, folderId, favoritesmodel)
            favoritesmanager.clearTree();
            popupmessage.show(qsTr("Favorites imported successfully"))
        }

        onParsingError: popupmessage.show(qsTr("Cannot import favorites"));
    }

    id: favoritessegment
    clip: true
    quickScroll: true
    model: FavoritesModel { id: favoritesmodel }

    header: Column {
        width: favoritessegment.width

        PageHeader {
            id: pageheader
            title: folderId === 0 ? qsTr("Favorites") : favoritesmodel.currentFolder()
        }

        Button {
            visible: folderId !== 0
            anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
            text: qsTr("Back")
            onClicked: favoritesmodel.jumpBack()
        }
    }

    delegate: FavoriteItem {
        contentWidth: favoritessegment.width
        contentHeight: Theme.itemSizeSmall
        title: model.title

        icon: {
            if(model.isfolder)
                return "image://theme/icon-m-folder";

            return mainwindow.settings.icondatabase.provideIcon(model.url);
        }

        onClicked: {
            if(model.isfolder) {
                favoritesmodel.jumpTo(model.favoriteid);
                favoritessegment.scrollToTop();
                return;
            }

            tabView.addTab(model.url);
            pageStack.pop();
        }
    }
}
