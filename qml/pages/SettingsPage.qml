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
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

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

            SectionHeader
            {
                text: qsTr("Privacy");
            }

            Row
            {
                width: parent.width
                height: Theme.itemSizeSmall

                TextSwitch
                {
                    id: swclearonexit
                    text: qsTr("Wipe Data on Exit")
                    width: parent.width
                    height: parent.height
                    checked: settings.clearonexit
                    onClicked: settings.clearonexit = checked
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
                                                         webkitdatabase.clearCache();
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
                labelText: qsTr("Delete Personal Data")
                actionMessage: qsTr("Removing personal data")

                onActionRequested: {
                    webkitdatabase.clearCache();
                    webkitdatabase.clearNavigationData();
                    Credentials.clear(Database.instance());
                    History.clear();
                }
            }
        }
    }

    onDone: {
        if(result === DialogResult.Accepted) {
            if(UrlHelper.isUrl(tfhomepage.text) || UrlHelper.isSpecialUrl(tfhomepage.text))
                settings.homepage = UrlHelper.adjustUrl(tfhomepage.text);

            settings.searchengine = cbsearchengines.currentIndex;
            settings.useragent = cbuseragent.currentIndex;

            Database.set("homepage", settings.homepage);
            Database.set("searchengine", settings.searchengine);
            Database.set("useragent", settings.useragent);
            Database.set("clearonexit", settings.clearonexit)
        }
    }
}
