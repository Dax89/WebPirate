import QtQuick 2.1
import Sailfish.Silica 1.0
import WebPirate.DBus.TransferEngine 1.0
import "../dialogs"

PopupDialog
{
    property string url;

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

        onClicked: {
            sharemenu.hide();
            pageStack.push(Qt.resolvedUrl(shareUIPath));
        }
    }
}
