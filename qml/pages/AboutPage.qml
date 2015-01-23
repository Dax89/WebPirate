import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import "../models"

Page
{
    property Settings settings

    property list<QtObject> translatormodel: [ QtObject { readonly property string language: qsTr("Catalan");
                                                          readonly property string translators: "fri666"; },

                                               QtObject { readonly property string language: qsTr("Chinese");
                                                          readonly property string translators: "gexc"; },

                                               QtObject { readonly property string language: qsTr("Dutch");
                                                          readonly property string translators: "Vistaus, pljmn"; },

                                               QtObject { readonly property string language: qsTr("French");
                                                          readonly property string translators: "Jordi, pljmn"; },

                                               QtObject { readonly property string language: qsTr("German");
                                                          readonly property string translators: "Moth, blubdbibub, snowpolloi"; },

                                               QtObject { readonly property string language: qsTr("Russian");
                                                          readonly property string translators: "lewa"; },

                                               QtObject { readonly property string language: qsTr("Swedish");
                                                          readonly property string translators: "eson"; } ]

    id: aboutpage
    allowedOrientations: Orientation.All

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            PageHeader
            {
                id: pageheader
                title: qsTr("About Web Pirate")
            }

            Image
            {
                id: wplogo
                anchors.horizontalCenter: parent.horizontalCenter
                width: 86
                height: 86
                source: "qrc:///harbour-webpirate.png"
            }

            Label
            {
                id: wpswname
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                text: "Web Pirate"
            }

            Label
            {
                id: wpversion
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Version") + " " + settings.version
            }

            Item
            {
                width: parent.width
                height: Theme.paddingLarge + wpinfo.height

                Label
                {
                    id: wpinfo
                    anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.paddingSmall; topMargin: Theme.paddingLarge; rightMargin: Theme.paddingSmall }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.WordWrap
                    text: qsTr("A tabbed Web Browser for SailfishOS based on WebKit")
                }
            }

            Item
            {
                width: parent.width
                height: Theme.paddingLarge + lbldev.height + lblrepository.height

                InfoLabel
                {
                    id: lbldev
                    anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.paddingSmall; topMargin: Theme.paddingLarge; rightMargin: Theme.paddingSmall }
                    title: qsTr("Developer")
                    text: "Antonio Davide Trogu"
                }

                InfoLabel
                {
                    id: lblrepository
                    anchors { left: parent.left; top: lbldev.bottom; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                    title: qsTr("GitHub Repository")
                    text: "https://github.com/Dax89/harbour-webpirate";
                }
            }

            Item
            {
                width: parent.width
                height: sectionhdr.height

                SectionHeader
                {
                    id: sectionhdr
                    width: parent.width
                    anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                    text: qsTr("Translators")
                }
            }

            Column
            {
                id: coltranslators
                width: parent.width

                Repeater
                {
                    model: translatormodel

                    delegate: InfoLabel {
                        anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; topMargin: Theme.paddingMedium; rightMargin: Theme.paddingSmall }
                        title: language
                        text: translators
                    }
                }
            }
        }
    }
}
