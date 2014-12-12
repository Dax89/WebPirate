import QtQuick 2.0
import Sailfish.Silica 1.0
import "../models"
import "../js/SearchEngines.js" as SearchEngines
import "../js/Database.js" as Database

Page
{
    property Settings settings

    signal defaultEngineChanged(int newindex)

    id: dlgsearchengines
    allowedOrientations: Orientation.All

    SilicaFlickable
    {
        id: dlgcontainer
        anchors.fill: parent

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Add")
                onClicked: pageStack.push(Qt.resolvedUrl("SearchEnginePage.qml"), { "settings": settings })
            }
        }

        PageHeader {
            id: pageheader
            title: qsTr("Search Engines")
        }

        ListView
        {
            id: lvsearchengines
            model: settings.searchengines
            anchors.top: pageheader.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            currentIndex: settings.searchengine;

            onCurrentIndexChanged: {
                if(currentIndex !== settings.searchengine)
                    defaultEngineChanged(currentIndex)
            }

            delegate: ListItem {
                id: listitem
                contentHeight: Theme.itemSizeSmall
                width: lvsearchengines.width

                Label {
                    id: lbltitle;
                    anchors.fill: parent
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    truncationMode: TruncationMode.Fade
                    color: (index === lvsearchengines.currentIndex) ? Theme.highlightColor : Theme.primaryColor
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Set as Default");

                        onClicked: {
                            lvsearchengines.currentIndex = index
                        }
                    }

                    MenuItem {
                        text: qsTr("Edit");
                        onClicked: pageStack.push(Qt.resolvedUrl("SearchEnginePage.qml"), { "settings": settings, "index": index, "name": name, "query": query })
                    }

                    MenuItem {
                        text: qsTr("Delete");

                        onClicked: listitem.remorseAction(qsTr("Deleting Search Engine"),
                                                          function() {
                                                              if(settings.searchengine === index) {
                                                                  Database.set("searchengine", settings.searchengine); /* Update Database Immediately */
                                                              }

                                                              SearchEngines.remove(Database.instance(), settings.searchengines, name);
                                                          });
                    }
                }
            }
        }
    }
}
