import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.DBus.TransferEngine 1.0

SilicaListView
{
    property var content

    function share(urltitle, shareurl) {
        if(!sharemenu.content)
            sharemenu.content = new Object;

        sharemenu.content.linkTitle = urltitle;
        sharemenu.content.status = shareurl;
        sharemenu.visible = true;
    }

    id: sharemenu
    visible: false
    clip: true

    model: TransferMethodModel {
        id: transfermethodmodel
        filter: "text/x-url"
        transferEngine: mainwindow.settings.transferengine
    }

    delegate: ListItem {
        width: sharemenu.width
        contentHeight: Theme.itemSizeSmall

        Label {
            id: lbltext
            anchors.fill: parent
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: methodId + (userName.length ? " (" + userName + ")" : "")
        }

        onClicked: {
            sharemenu.content.type = transfermethodmodel.filter; // Set Filter before open a new page
            sharemenu.visible = false;

            pageStack.push(Qt.resolvedUrl(shareUIPath), { "methodId": methodId, "accountId": accountId, "content": sharemenu.content } );
        }
    }
}
