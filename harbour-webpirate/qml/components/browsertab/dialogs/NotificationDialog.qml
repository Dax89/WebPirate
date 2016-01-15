import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/UrlHelper.js" as UrlHelper

PopupDialog
{
    signal requestAccepted()
    signal requestRejected()

    id: notificationdialog
    popupModel: 1
    onRequestAccepted: webview.experimental.postMessage("notification_granted")
    onRequestRejected: webview.experimental.postMessage("notification_denied");

    onVisibleChanged: {
        if(!visible)
            return;

        notificationdialog.title = "'" + UrlHelper.domainName(webview.url.toString()) + "' " + qsTr("wants to access System's Notifications");
    }

    popupDelegate: Row {
        width: parent.width
        height: Theme.itemSizeSmall

        BackgroundItem
        {
            width: parent.width / 2
            height: parent.height

            Label
            {
                id: lblallow
                text: qsTr("Allow");
                anchors.fill: parent
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                notificationdialog.hide();
                requestAccepted();
            }
        }

        BackgroundItem
        {
            width: parent.width / 2
            height: parent.height

            Label
            {
                id: lbldeny
                text: qsTr("Deny");
                anchors.fill: parent
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                notificationdialog.hide();
                requestRejected();
            }
        }
    }
}
