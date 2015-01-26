import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../js/Database.js" as Database
import "../../js/Credentials.js" as Credentials

RequestMenu
{
    property string url
    property var logindata

    id: credentialmenu
    title: qsTr("Do you want to store the password?")

    function clearData() {
        credentialmenu.url = "";
        credentialmenu.logindata = null;
    }

    onRequestAccepted: {
        Credentials.store(Database.instance(), mainwindow.settings, credentialmenu.url, logindata);
        clearData();
    }

    onRequestRejected: clearData()
}
