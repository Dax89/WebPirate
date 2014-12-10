import QtQuick 2.0
import Sailfish.Silica 1.0
import "../models"
import "../js/UrlHelper.js" as UrlHelper
import "../js/Database.js" as Database

Dialog
{
    property Settings settings

    id: dlgsettings
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    SilicaFlickable
    {
        id: dlgcontainer
        anchors.fill: parent

        DialogHeader
        {
            id: dlgheader
            title: qsTr("Save Settings")
        }

        Column
        {
            anchors.top: dlgheader.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            TextField
            {
                id: tfhomepage
                label: qsTr("Home Page")
                width: parent.width
                text: settings.homepage
            }

            ComboBox
            {
                id: cbsearchengines
                label: qsTr("Search Engines")
                width: parent.width
                currentIndex: {
                    for(var i = 0; i < settings.searchengines.count; i++) {
                        if(settings.searchengines.get(i).name === settings.searchengine.name) {
                            currentIndex = i;
                            break;
                        }
                    }
                }

                menu: ContextMenu {
                    Repeater {
                        model: settings.searchengines

                        MenuItem {
                            text: name
                        }
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
        }
    }

    onDone: {
        if(result === DialogResult.Accepted) {
            if(UrlHelper.isUrl(tfhomepage.text))
                settings.homepage = UrlHelper.adjustUrl(tfhomepage.text);

            settings.searchengine = settings.searchengines.get(cbsearchengines.currentIndex);
            settings.useragent = cbuseragent.currentIndex;
            Database.save();
        }
    }
}
