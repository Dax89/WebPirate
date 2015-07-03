import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../js/UrlHelper.js" as UrlHelper
import "../../js/settings/Database.js" as Database
import "../../js/settings/UserAgents.js" as UserAgents

Dialog
{
    property Settings settings

    id: dlggeneralsettings
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    onAccepted: {
        if(UrlHelper.isUrl(tfhomepage.text) || UrlHelper.isSpecialUrl(tfhomepage.text))
            settings.homepage = UrlHelper.adjustUrl(tfhomepage.text);

        settings.searchengine = cbsearchengines.currentIndex;
        settings.useragent = cbuseragent.currentIndex;

        Database.transaction(function(tx) {
            Database.transactionSet(tx, "homepage", settings.homepage);
            Database.transactionSet(tx, "searchengine", settings.searchengine);
            Database.transactionSet(tx, "useragent", settings.useragent);
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

            TextField
            {
                id: tfhomepage
                label: qsTr("Home Page")
                width: parent.width
                inputMethodHints: Qt.ImhUrlCharactersOnly
                text: settings.homepage
            }

            ComboBox
            {
                id: cbsearchengines
                label: qsTr("Search Engines")
                description: qsTr("Long press to edit")
                currentIndex: settings.searchengine
                width: parent.width

                menu: ContextMenu {
                    Repeater {
                        model: settings.searchengines

                        MenuItem {
                            text: name
                        }
                    }
                }

                onPressAndHold: {
                    var page = pageStack.push(Qt.resolvedUrl("../searchengine/SearchEnginesPage.qml"), {"settings": settings });
                    page.defaultEngineChanged.connect(function(newindex) {
                        cbsearchengines.currentIndex = newindex;
                    });
                }
            }

            ComboBox
            {
                id: cbuseragent
                label: qsTr("User Agent")
                width: parent.width
                currentIndex: settings.useragent

                menu: ContextMenu {

                    Repeater {
                        model: UserAgents.defaultuseragents

                        MenuItem {
                            text: UserAgents.get(index).type
                        }
                    }
                }
            }

        }
    }
}
