import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.LocalStorage 1.0
import harbour.webpirate.Selectors 1.0

Page
{
    property Page returnPage
    property FavoritesManager favoritesManager

    property list<QtObject> importtypes: [ Item { readonly property string title: qsTr("From HTML File")

                                                  function execute() {
                                                      var page = pageStack.push(Qt.resolvedUrl("../../selector/SelectorFilesPage.qml"), { "filter": FilesModel.HtmlFilter });

                                                      page.actionCompleted.connect(function(action, data) {
                                                          favoritesManager.importFile(data);
                                                          pageStack.completeAnimation();
                                                          pageStack.pop(returnPage);
                                                      });
                                                  } },

                                           Item { readonly property string title: qsTr("From Sailfish Browser")

                                                  function execute() {
                                                      favoritesManager.importFromSailfishBrowser();
                                                      pageStack.completeAnimation();
                                                      pageStack.pop(returnPage);
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

            onClicked: {
                if(index == 0) {
                    importtypes[index].execute();
                    return;
                }

                remorseAction(qsTr("Imporing Favorites"), function() {
                    importtypes[index].execute();
                });
            }

            Label {
                anchors { fill: parent; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                text: title
            }
        }
    }
}
