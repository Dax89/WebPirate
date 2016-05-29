import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../js/settings/Database.js" as Database

Dialog
{
    property Settings settings

    id: dlggeneralsettings
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    onAccepted: {
        Database.transaction(function(tx) {
            Database.transactionSet(tx, "overridetextfields", settings.exp_overridetextfields);
            Database.transactionSet(tx, "ambiencebrowsing", settings.exp_ambiencebrowsing);
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
                id: swoverridetextfields
                text: qsTr("Override Text Fields")
                description: qsTr("Use SailfishOS's editing components instead of WebView's ones")
                width: parent.width
                checked: settings.exp_overridetextfields

                onCheckedChanged: {
                    settings.exp_overridetextfields = checked;
                }
            }

            TextSwitch
            {
                id: swambieencebrowsing
                text: qsTr("Ambience Browsing")
                description: qsTr("WebPirate will try to skin webpages according to ambience settings")
                width: parent.width
                checked: settings.exp_ambiencebrowsing

                onCheckedChanged: {
                    settings.exp_ambiencebrowsing = checked;
                }
            }
        }
    }
}
