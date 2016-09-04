import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../models/navigationbar"
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
    Component.onCompleted: settings.defaultbrowser.checkDefaultBrowser()

    onAccepted: {
        if(UrlHelper.isUrl(tfhomepage.text) || UrlHelper.isSpecialUrl(tfhomepage.text))
            settings.homepage = UrlHelper.adjustUrl(tfhomepage.text);

        settings.searchengine = cbsearchengines.currentIndex;
        settings.useragent = cbuseragent.currentIndex;
        settings.presscustomaction = cbcustomactionpress.currentIndex;
        settings.longpresscustomaction = cbcustomactionlongpress.currentIndex;
        settings.lefthanded = swlefthandedmode.checked;

        Database.transaction(function(tx) {
            Database.transactionSet(tx, "homepage", settings.homepage);
            Database.transactionSet(tx, "searchengine", settings.searchengine);
            Database.transactionSet(tx, "useragent", settings.useragent);
            Database.transactionSet(tx, "presscustomaction", settings.presscustomaction);
            Database.transactionSet(tx, "longpresscustomaction", settings.longpresscustomaction);
            Database.transactionSet(tx, "lefthanded", settings.lefthanded);
        });
    }

    CustomActionsModel { id: customactions }

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
                id: swlefthandedmode
                text: qsTr("Left handed mode")
                width: parent.width
                checked: settings.lefthanded
            }

            TextSwitch
            {
                id: swdefaultbrowser
                text: qsTr("Set as default browser")
                width: parent.width
                busy: settings.defaultbrowser.busy
                checked: settings.defaultbrowser.enabled

                onCheckedChanged: {
                    settings.defaultbrowser.enabled = checked;
                }
            }

            SectionHeader { text: qsTr("Custom actions") }

            ComboBox
            {
                id: cbcustomactionpress
                label: qsTr("Pressed")
                width: parent.width
                currentIndex: settings.presscustomaction

                menu: ContextMenu {
                    Repeater {
                        model: customactions.actionmodel

                        MenuItem {
                            text: customactions.actionmodel[index].name
                        }
                    }
                }
            }

            ComboBox
            {
                id: cbcustomactionlongpress
                label: qsTr("Long Pressed")
                width: parent.width
                enabled: cbcustomactionpress.currentIndex !== 0
                currentIndex: settings.longpresscustomaction

                menu: ContextMenu {
                    Repeater {
                        model: customactions.actionmodel

                        MenuItem {
                            text: customactions.actionmodel[index].name
                        }
                    }
                }
            }
        }
    }
}
