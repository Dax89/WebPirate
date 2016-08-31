import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../models"

Page
{
    property Settings settings

    id: aboutpage

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("GitHub Repository")
                onClicked: Qt.openUrlExternally("https://github.com/Dax89/harbour-webpirate")
            }

            MenuItem
            {
                text: qsTr("Report an Issue")
                onClicked: Qt.openUrlExternally("https://github.com/Dax89/harbour-webpirate/issues")
            }
        }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader
            {
                id: pageheader
                title: qsTr("About WebPirate")
            }

            Image
            {
                id: wplogo
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                width: Theme.iconSizeLarge
                height: Theme.iconSizeLarge
                source: "qrc:///harbour-webpirate.png"
            }

            Column
            {
                anchors { left: parent.left; right: parent.right }

                Label
                {
                    id: wpswname
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    font.pixelSize: Theme.fontSizeLarge
                    text: "WebPirate"
                }

                Label
                {
                    id: wpinfo
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                    text: qsTr("A tabbed Web Browser for SailfishOS based on WebKit")
                }

                Label
                {
                    id: vpversion
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                    text: qsTr("Version") + " " + settings.version
                }

                Label
                {
                    id: wpcopyright
                    anchors { left: parent.left; right: parent.right }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.WordWrap
                    color: Theme.secondaryColor
                    text: qsTr("WebPirate is distributed under the GPLv3 license")
                }
            }

            Column
            {
                anchors { left: parent.left; right: parent.right; topMargin: Theme.paddingExtraLarge }
                spacing: Theme.paddingSmall

                Button
                {
                    id: licensebutton
                    text: qsTr("License")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: Qt.openUrlExternally("https://raw.githubusercontent.com/Dax89/harbour-webpirate/master/LICENSE")
                }

                Button
                {
                    id: developersbutton
                    text: qsTr("Developers")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: pageStack.push(Qt.resolvedUrl("DevelopersPage.qml"))
                }

                Button
                {
                    id: translationsbutton
                    text: qsTr("Translations")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: pageStack.push(Qt.resolvedUrl("TranslationsPage.qml"))
                }

                Button
                {
                    id: thirdpartybutton
                    text: qsTr("Third Party")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: pageStack.push(Qt.resolvedUrl("ThirdPartyPage.qml"))
                }
            }
        }
    }
}
