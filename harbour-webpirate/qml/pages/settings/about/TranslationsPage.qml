import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.Translation 1.0
import "../../../components"

Page
{
    id: translationspage
    allowedOrientations: Orientation.Portrait

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        VerticalScrollDecorator { flickable: parent }

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Translation Platform")
                onClicked: Qt.openUrlExternally("https://www.transifex.com/sailfishos-apps/webpirate")
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
                title: qsTr("Translations")
            }

            Repeater
            {
                id: contentview
                model: TranslationsModel { }

                delegate: Column {
                    anchors { left: parent.left; right: parent.right }
                    spacing: Theme.paddingMedium

                    Label {
                        anchors { left: parent.left; right: parent.right }
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.secondaryHighlightColor
                        text: model.item.name
                        font.bold: true
                    }

                    CollaboratorsLabel {
                        title: qsTr("Coordinators");
                        labeldata: model.item.coordinators
                    }

                    CollaboratorsLabel {
                        title: qsTr("Translators");
                        labeldata: model.item.translators
                    }

                    CollaboratorsLabel {
                        title: qsTr("Reviewers");
                        labeldata: model.item.reviewers
                    }
                }
            }
        }
    }
}
