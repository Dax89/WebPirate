import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../js/Database.js" as Database
import "../../js/Credentials.js" as Credentials

PopupMenu
{
    property string url
    property var logindata

    id: credentialmenu
    title: qsTr("Do you want to store the password?")
    popupModel: 1

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
                credentialmenu.hide();

                Credentials.store(Database.instance(), mainwindow.settings, credentialmenu.url,
                                  credentialmenu.logindata.loginattribute, credentialmenu.logindata.loginid, credentialmenu.logindata.login,
                                  credentialmenu.logindata.passwordattribute, credentialmenu.logindata.passwordid, credentialmenu.logindata.password);
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
                credentialmenu.hide();
            }
        }
    }

    onVisibleChanged: {
        if(visible === false)
        {
            credentialmenu.url = "";
            credentialmenu.logindata = null;
        }
    }
}
