import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.DBus.TransferEngine 1.0
import "../components"

SilicaListView
{
    property var content

    function share(urltitle, shareurl) {
        if(!sharemenu.content)
            sharemenu.content = new Object;

        transfermethodmodel.transferEngine = mainwindow.settings.transferengine;

        sharemenu.content.linkTitle = urltitle;
        sharemenu.content.status = shareurl;
        sharemenu.visible = true;
    }

    id: sharemenu
    visible: false
    clip: true

    DialogBackground {
        anchors.fill: parent
    }

    model: TransferMethodModel {
        id: transfermethodmodel
        filter: "text/x-url"
    }

    delegate: ListItem {
        contentWidth: sharemenu.width
        contentHeight: Theme.itemSizeSmall

        Label {
            anchors { fill: parent; bottomMargin: Theme.paddingSmall }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            text: methodId + ((userName && userName.length) ? " (" + userName + ")" : "")
        }

        onClicked: {
            sharemenu.content.type = transfermethodmodel.filter; // Set Filter before open a new page
            sharemenu.visible = false;

            pageStack.push(Qt.resolvedUrl(shareUIPath), { "methodId": methodId, "accountId": accountId, "content": sharemenu.content } );
        }
    }
}
