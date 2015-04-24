import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/settings/Favorites.js" as Favorites
import "../dialogs"

PopupDialog
{
    property string url;
    property bool favorite: false
    property bool isimage: false

    property list<QtObject> linkmenuModel: [ QtObject { readonly property string menuText: qsTr("Open")
                                                        function execute() {
                                                            linkmenu.openLinkRequested(linkmenu.url);
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: qsTr("Open New Tab")
                                                        function execute() {
                                                            linkmenu.openTabRequested(linkmenu.url, true);
                                                        }
                                                      },

                                            QtObject { readonly property string menuText: qsTr("Open New Tab in Background")
                                                       function execute() {
                                                           linkmenu.openTabRequested(linkmenu.url, false);
                                                       }
                                                     },

                                             QtObject { readonly property string menuText: qsTr("Copy Link")
                                                        function execute() {
                                                            Clipboard.text = linkmenu.url;
                                                            popupmessage.show(qsTr("Link copied to clipboard"));
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: linkmenu.isimage ? qsTr("Save Image") : qsTr("Save Link Destination")
                                                        function execute() {
                                                            tabviewremorse.execute(isimage ? qsTr("Downloading image") : qsTr("Downloading link"), function() {
                                                                mainwindow.settings.downloadmanager.createDownloadFromUrl(linkmenu.url);
                                                            });
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: qsTr("Share")
                                                        function execute() {
                                                            sharemenu.share(linkmenu.url, linkmenu.url);
                                                        }
                                                      },

                                             QtObject { readonly property string menuText: linkmenu.favorite ? qsTr("Remove From Favorites") : qsTr("Add To Favorites")
                                                        function execute() {
                                                            if(!linkmenu.favorite) {
                                                                linkmenu.addToFavoritesRequested(linkmenu.url);
                                                                linkmenu.favorite = true;
                                                            }
                                                            else {
                                                                linkmenu.removeFromFavoritesRequested(linkmenu.url);
                                                                linkmenu.favorite = false;
                                                            }
                                                        }
                                                      } ]

    signal openLinkRequested(string url)
    signal openTabRequested(string url, bool foreground)
    signal addToFavoritesRequested(string url)
    signal removeFromFavoritesRequested(string url)

    id: linkmenu
    titleVisible: true
    anchors.fill: parent

    onUrlChanged: {
        linkmenu.favorite = Favorites.contains(linkmenu.url);
        linkmenu.title = url;
    }

    popupModel: linkmenuModel

    popupDelegate: ListItem {
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall

        Label {
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: linkmenuModel[index].menuText
        }

        onClicked: {
            linkmenu.hide();
            linkmenuModel[index].execute();
        }
    }
}
