import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate.DBus.TransferEngine 1.0
import "../dialogs"

PopupDialog
{
    property string url;

    /*
    property list<QtObject> sharemenuModel: [ QtObject { readonly property string menuIcon: "image://theme/icon-lock-facebook"
                                                        readonly property string menuText: qsTr("Share on Facebook")
                                                        function execute() {
                                                            shareRequested("https://www.facebook.com/sharer/sharer.php?u=" + sharemenu.url);
                                                        }
                                                      },

                                             QtObject { readonly property string menuIcon: "image://theme/icon-lock-twitter"
                                                        readonly property string menuText: qsTr("Share on Twitter")
                                                        function execute() {
                                                            shareRequested("https://twitter.com/intent/tweet?url=" + sharemenu.url);

                                                        }
                                                      },

                                            QtObject { readonly property string menuIcon: "qrc:///res/googleplus.png"
                                                       readonly property string menuText: qsTr("Share on Google+")
                                                       function execute() {
                                                           shareRequested("https://plus.google.com/share?url=" + sharemenu.url);
                                                       }
                                                     } ] */


    signal shareRequested(string sharedurl)

    function share(shareurl) {
        sharemenu.url = shareurl;
        sharemenu.show();
    }

    id: sharemenu
    titleVisible: true
    anchors.fill: parent

    onUrlChanged: {
        sharemenu.title = qsTr("Share") + ":\n" + url;
    }

    popupModel: TransferMethodModel {
        filter: "text/x-url"
        transferEngine: mainwindow.settings.transferengine
    }

    popupDelegate: ListItem {
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall

        Label {
            id: lbltext
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: methodId + (userName.length ? " (" + userName + ")" : "")
        }

        /*
        Row
        {
            anchors { fill: parent; leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge }
            spacing: Theme.paddingMedium

            Image {
                id: imglogo
                anchors.verticalCenter: lbltext.verticalCenter
                width: lbltext.contentHeight
                height: lbltext.contentHeight
                fillMode: Image.PreserveAspectFit
                source: sharemenuModel[index].menuIcon
            }

            Label {
                id: lbltext
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeSmall
                text: sharemenuModel[index].menuText
            }
        }
        */

        onClicked: {
            sharemenu.hide();
            //sharemenuModel[index].execute();
            pageStack.push(Qt.resolvedUrl(shareUIPath));
        }
    }
}
