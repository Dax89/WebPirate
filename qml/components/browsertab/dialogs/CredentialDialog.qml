import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/Database.js" as Database
import "../../../js/Credentials.js" as Credentials

PopupDialog
{
    property string url
    property var logindata

    signal requestAccepted()
    signal requestRejected()

    function clearData() {
        credentialdialog.url = "";
        credentialdialog.logindata = null;
    }

    id: credentialdialog
    popupModel: 1
    title: qsTr("Do you want to store the password?")

    onRequestAccepted: {
        Credentials.store(Database.instance(), mainwindow.settings, credentialdialog.url, logindata);
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
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                credentialdialog.hide();
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
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                credentialdialog.hide();
                requestRejected();
            }
        }
    }
}
