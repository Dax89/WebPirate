import QtQuick 2.0
import Sailfish.Silica 1.0
import "../models"
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database
import "../js/Credentials.js" as Credentials

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
                title: qsTr("Save Settings")
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
                text: settings.homepage
            }

            Row
            {
                width: parent.width

                ComboBox
                {
                    id: cbsearchengines
                    label: qsTr("Search Engines")
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
                        var page = pageStack.push(Qt.resolvedUrl("SearchEnginesPage.qml"), {"settings": settings });
                        page.defaultEngineChanged.connect(function(newindex) {
                            cbsearchengines.currentIndex = newindex;
                        });
                    }
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
                        model: settings.useragents

                        MenuItem {
                            text: type
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

                Switch
                {
                    id: swclearonexit
                    width: Theme.itemSizeSmall
                    height: parent.height
                    checked: settings.clearonexit

                    onCheckedChanged: {
                        settings.clearonexit = checked;
                    }
                }

                Label
                {
                    id: lblwipedata
                    height: parent.height
                    width: parent.width - swclearonexit.width
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Wipe Data on Exit");
                }
            }

            Item
            {
                width: parent.width
                height: Theme.itemSizeSmall

                BackgroundItem
                {
                    id: bideletepersdata
                    anchors.fill: parent

                    RemorseItem { id: rideletepersdata }

                    Label
                    {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.paddingLarge
                        text: qsTr("Delete Personal Data");
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: rideletepersdata.execute(bideletepersdata, qsTr("Deleting personal data"),
                                                        function() {
                                                            Credentials.clear(Database.instance());
                                                        });
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
