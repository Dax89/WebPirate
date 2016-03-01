import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../js/settings/Database.js" as Database
import "../../../js/settings/Credentials.js" as Credentials

JavaScriptDialog // Not really a JS Dialog, but looks similar
{
    property string url
    property var logindata

    function clearData() {
        credentialdialog.url = "";
        credentialdialog.logindata = null;
    }

    id: credentialdialog
    title: qsTr("Do you want to store the password?")

    Row
    {
        parent: credentialdialog.contentItem
        width: parent.width
        spacing: Theme.paddingSmall

        Button
        {
            id: lblyes
            width: (parent.width / 2) - Theme.paddingSmall
            text: qsTr("Yes")

            onClicked: {
                Credentials.store(Database.instance(), credentialdialog.url, logindata);
                accept();
                clearData();
            }
        }

        Button
        {
            id: lblno
            width: parent.width / 2
            text: qsTr("No")

            onClicked: {
                reject();
                clearData();
            }
        }
    }
}

