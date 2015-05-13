import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"
import "../models"
import "../js/UrlHelper.js" as UrlHelper
import "../js/settings/Database.js" as Database
import "../js/settings/Credentials.js" as Credentials
import "../js/settings/History.js" as History
import "../js/settings/UserAgents.js" as UserAgents

Dialog
{
    property Settings settings

    id: dlgsettings
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
            Database.transactionSet(tx, "clearonexit", settings.clearonexit);
            Database.transactionSet(tx, "keepfavicons", settings.keepfavicons);
            Database.transactionSet(tx, "restoretabs", settings.restoretabs);
        });
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height + dlgheader.height

        Column
        {
            id: column
            anchors.top: parent.top
            width: parent.width

            DialogHeader
            {
                id: dlgheader
                acceptText: qsTr("Save Settings")
            }

            SectionHeader
            {
                text: qsTr("General");
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
                    var page = pageStack.push(Qt.resolvedUrl("searchengine/SearchEnginesPage.qml"), {"settings": settings });
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

            SectionHeader
            {
                text: qsTr("Privacy");
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

            /*
            Item
            {
                width: parent.width
                height: Theme.itemSizeSmall

                BackgroundItem
                {
                    id: bideletecache
                    anchors.fill: parent

                    RemorseItem { id: rideletecache }

                    Label
                    {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.paddingLarge
                        text: qsTr("Delete Cache")
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: rideletecache.execute(bideletecache, qsTr("Removing cache"),
                                                     function() {
                                                         settings.webkitdatabase.clearCache();
                                                     });
                }
            }
            */

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                labelText: qsTr("Delete Navigation History")
                actionMessage: qsTr("Removing navigation history")

                onActionRequested: History.clear()
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                labelText: qsTr("Delete Cookies")
                actionMessage: qsTr("Removing cookies")

                onActionRequested: settings.cookiejar.deleteAllCookies()
            }

            SettingLabel
            {
                width: parent.width
                height: Theme.itemSizeSmall
                labelText: qsTr("Delete Personal Data")
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
