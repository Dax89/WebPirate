import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../js/settings/Database.js" as Database

Dialog
{
    property Settings settings

    id: dlgtabssettings
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    onAccepted: {
        Database.transaction(function(tx) {
            Database.transactionSet(tx, "restoretabs", settings.restoretabs);
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

            TextSwitch
            {
                id: swrestoretabs
                text: qsTr("Restore tabs at Startup")
                width: parent.width
                checked: settings.restoretabs

                onCheckedChanged: {
                    settings.restoretabs = checked;
                }
            }
        }
    }
}
