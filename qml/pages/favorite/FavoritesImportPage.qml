import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.LocalStorage 1.0
import "../../models"
import "../../js/settings/Favorites.js" as Favorites

Page
{
    property FavoritesManager favoritesManager;
    property Page rootPage

    property list<QtObject> importtypes: [ Item { readonly property string title: qsTr("From HTML File")

                                                  function execute() {
                                                      var page = pageStack.push(Qt.resolvedUrl("../picker/FilePickerPage.qml"), { "filter": "*.htm;*.html", "rootPage": rootPage });

                                                      page.filePicked.connect(function(file) {
                                                          favoritesManager.importFile(file);
                                                      });
                                                  } },

                                           Item { readonly property string title: qsTr("From Sailfish Browser")

                                                  function execute() {
                                                      favoritesManager.importFromSailfishBrowser();
                                                      pageStack.pop(rootPage);
                                                  } } ]

    id: favoriteimportspage
    allowedOrientations: defaultAllowedOrientations

    SilicaListView
    {
        header: PageHeader { title: qsTr("Import Favorites") }
        anchors.fill: parent
        model: importtypes

        delegate: ListItem {
            height: Theme.itemSizeSmall
            width: parent.width
            onClicked: importtypes[index].execute()

            Label {
                anchors { fill: parent; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                text: title
            }
        }
    }
}
