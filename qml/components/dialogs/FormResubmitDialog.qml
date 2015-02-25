import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/Database.js" as Database
import "../../js/Credentials.js" as Credentials

PopupDialog
{
    property string url

    signal requestAccepted()
    signal requestRejected()

    function clearData() {
        url = "";
    }

    id: formresubmitdialog
    popupModel: 1
    title: qsTr("This page contains information written by you: do you want to resend the data?")

    onRequestAccepted: {
        browsertab.load(url);
        clearData();
    }

    onRequestRejected: clearData()

    popupDelegate: Row {
        width: parent.width
        height: Theme.itemSizeSmall

        BackgroundItem
        {
            width: parent.width / 2
            height: parent.height

            Label
            {
                id: lblyes
                text: qsTr("Yes");
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                formresubmitdialog.hide();
                requestAccepted();
            }
        }

        BackgroundItem
        {
            width: parent.width / 2
            height: parent.height

            Label
            {
                id: lblno
                text: qsTr("No");
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                formresubmitdialog.hide();
                requestRejected();
            }
        }
    }
}
