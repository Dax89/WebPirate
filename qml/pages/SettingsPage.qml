import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/UrlHelper.js" as UrlHelper
import "../js/Settings.js" as Settings

Dialog
{
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
            title: "Save Settings"
        }

        Column
        {
            anchors.top: dlgheader.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            TextField
            {
                id: tfhomepage
                label: "Home Page"
                width: parent.width
                text: Settings.homepage
            }

            ComboBox
            {
                id: cbsearchengines
                label: "Search Engines"
                width: parent.width
                currentIndex: {
                    for(var i = 0; i < Settings.searchengines.length; i++) {
                        if(Settings.searchengines[i].name === Settings.defaultsearchengine.name) {
                            currentIndex = i;
                            break;
                        }
                    }
                }

                menu: ContextMenu {
                    Repeater {
                        model: Settings.searchengines

                        MenuItem {
                            text: Settings.searchengines[index].name
                        }
                    }
                }
            }

            ComboBox
            {
                id: cbuseragent
                label: "User Agent"
                width: parent.width
                currentIndex: Settings.useragenttype

                menu: ContextMenu {

                    Repeater {
                        model: Settings.useragents

                        MenuItem {
                            text: Settings.useragents[index].type
                        }
                    }
                }
            }
        }
    }

    onDone: {
        if(result === DialogResult.Accepted) {
            if(UrlHelper.isUrl(tfhomepage.text))
                Settings.homepage = UrlHelper.adjustUrl(tfhomepage.text);

            Settings.defaultsearchengine = Settings.searchengines[cbsearchengines.currentIndex];
            Settings.useragenttype = cbuseragent.currentIndex;
            Settings.save();
        }
    }
}
