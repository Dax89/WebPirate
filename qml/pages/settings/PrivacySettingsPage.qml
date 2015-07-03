import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components"
import "../../models"
import "../../js/settings/Database.js" as Database
import "../../js/settings/Credentials.js" as Credentials
import "../../js/settings/History.js" as History

Dialog
{
    property Settings settings

    id: dlgprivacy
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    onAccepted: {
        Database.transaction(function(tx) {
            Database.transactionSet(tx, "clearonexit", settings.clearonexit);
            Database.transactionSet(tx, "keepfavicons", settings.keepfavicons);
        });
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            DialogHeader
            {
                acceptText: qsTr("Save")
            }

            SectionHeader
            {
                text: qsTr("Privacy Options")
            }

            TextSwitch
            {
                id: swclearonexit
                text: qsTr("Wipe Data on Exit")
                width: parent.width
                checked: settings.clearonexit

                onCheckedChanged: {
                    settings.clearonexit = checked;
                }
            }

            TextSwitch
            {
                id: swkeepicons
                text: qsTr("Keep Favicons when deleting personal data")
                width: parent.width
                checked: settings.keepfavicons

                onCheckedChanged: {
                    settings.keepfavicons = checked;
                }
            }

            SectionHeader
            {
                text: qsTr("Privacy Management")
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                remorseRequired: true
                text: qsTr("Delete Navigation History")
                actionMessage: qsTr("Removing navigation history")

                onActionRequested: History.clear()
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                remorseRequired: true
                text: qsTr("Delete Cookies")
                actionMessage: qsTr("Removing cookies")

                onActionRequested: settings.cookiejar.deleteAllCookies()
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                remorseRequired: true
                text: qsTr("Delete Personal Data")
                actionMessage: qsTr("Removing personal data")

                onActionRequested: {
                    settings.webkitdatabase.clearCache();
                    settings.webkitdatabase.clearNavigationData(settings.keepfavicons);
                    Credentials.clear(Database.instance());
                    History.clear();
                }
            }

        }
    }
}
