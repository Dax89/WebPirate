import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"
import "../js/settings/Favorites.js" as Favorites

SilicaListView
{
    property string url
    property bool favorite: false
    property bool isImage: false

    property list<QtObject> linkmenuModel: [ QtObject { readonly property string menuText: qsTr("Open New Tab")
                                                        function execute() {
                                                            linkmenu.openTabRequested(linkmenu.url);
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: qsTr("Copy Link")
                                                        function execute() {
                                                            Clipboard.text = linkmenu.url;
                                                            popupmessage.show(qsTr("Link copied to clipboard"));
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: linkmenu.isImage ? qsTr("Save Image") : qsTr("Save Link Destination")
                                                        function execute() {
                                                            tabviewremorse.execute(isImage ? qsTr("Downloading image") : qsTr("Downloading link"), function() {
                                                                mainwindow.settings.downloadmanager.createDownloadFromUrl(linkmenu.url);
                                                            });
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: qsTr("Share")
                                                        function execute() {
                                                            sharemenu.share(linkmenu.title, linkmenu.url);
                                                        }
                                                      } ]

    signal openTabRequested(string url)
    signal addToFavoritesRequested(string url)
    signal removeFromFavoritesRequested(string url)

    id: linkmenu
    visible: false
    clip: true

    DialogBackground {
        anchors.fill: parent
    }

    onUrlChanged: {
        linkmenu.favorite = Favorites.contains(linkmenu.url);
    }

    model: linkmenuModel

    delegate: ListItem {
        contentWidth: linkmenu.width
        contentHeight: Theme.itemSizeSmall

        Label {
            anchors { fill: parent; bottomMargin: Theme.paddingSmall }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: linkmenuModel[index].menuText
        }

        onClicked: {
            linkmenu.visible = false;
            linkmenuModel[index].execute();
        }
    }
}
