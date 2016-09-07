import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../../components"

Page
{
    id: developerspage
    allowedOrientations: Orientation.Portrait

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        VerticalScrollDecorator { flickable: parent }

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("Developers") }

            CollaboratorsLabel {
                title: qsTr("Author");
                labeldata: [ "Antonio Davide Trogu" ]
            }

            CollaboratorsLabel {
                title: qsTr("Contributor");
                labeldata: [ "Ferlanero" ]
            }

            CollaboratorsLabel {
                title: qsTr("Icon Designers");
                labeldata: [ "Dax", "@geekonerd" ]
            }
        }
    }
}
