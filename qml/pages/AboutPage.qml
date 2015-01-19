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
        contentHeight: 1306

        PageHeader
        {
            id: pageheader
            title: qsTr("About Web Pirate")
        }

        Image
        {
            id: wplogo
            anchors { top: pageheader.bottom; horizontalCenter: parent.horizontalCenter }
            width: 86
            height: 86
            source: "qrc:///harbour-webpirate.png"
        }

        Label
        {
            id: wpswname
            anchors { top: wplogo.bottom; horizontalCenter: parent.horizontalCenter}
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            text: "Web Pirate"
        }

        Label
        {
            id: wpversion
            anchors { top: wpswname.bottom; horizontalCenter: parent.horizontalCenter}
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            text: qsTr("Version") + " " + settings.version
        }

        Label
        {
            id: wpinfo
            anchors { top: wpversion.bottom; left: parent.left; right: parent.right; leftMargin: Theme.paddingMedium; topMargin: Theme.paddingLarge; rightMargin: Theme.paddingMedium }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            wrapMode: Text.WordWrap
            text: qsTr("A tabbed Web Browser for SailfishOS based on WebKit")
        }

        Item
        {
            id: wpdata
            anchors { left: parent.left; top: wpinfo.bottom; right: parent.right; bottom: parent.bottom;
                      leftMargin: Theme.paddingMedium; topMargin: Theme.paddingSmall; rightMargin: Theme.paddingMedium; bottomMargin: Theme.paddingMedium }

            InfoLabel
            {
                id: lbldev
                anchors { left: parent.left; top: parent.top; topMargin: Theme.paddingMedium }
                title: qsTr("Developer")
                text: "Antonio Davide Trogu"
            }

            InfoLabel
            {
                id: lblrepository
                anchors { left: parent.left; top: lbldev.bottom; topMargin: Theme.paddingMedium }
                title: qsTr("GitHub Repository")
                text: "https://github.com/Dax89/harbour-webpirate";
            }

            SectionHeader
            {
                id: sectionhdr
                anchors { left: parent.left; top: lblrepository.bottom; right: parent.right }
                text: qsTr("Translators")
            }

            Column
            {
                id: coltranslators
                anchors { left: parent.left; top: sectionhdr.bottom; right: parent.right; bottom: parent.bottom }

                Repeater
                {
                    anchors { left: parent.left; right: parent.right }
                    model: translatormodel

                    delegate: InfoLabel {
                        anchors { left: parent.left; right: parent.right; topMargin: Theme.paddingMedium }
                        title: language
                        text: translators
                    }
                }
            }
        }
    }
}
