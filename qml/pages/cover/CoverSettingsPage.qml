import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../models"

Page
{
    property Settings settings
    property list<QtObject> coversettingsmodel: [ QtObject { readonly property string actionName: qsTr("General Actions") },
                                                  QtObject { readonly property string actionName: qsTr("Quick Grid Actions") } ]

    id: coversettingspage
    allowedOrientations: Orientation.All

    PageHeader { id: pageheader; title: qsTr("Cover Manager") }

    SilicaListView
    {
        anchors { left: parent.left; top: pageheader.bottom; right: parent.right; bottom: parent.bottom }
        model: coversettingsmodel

        delegate: ListItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall
            onClicked: pageStack.push(Qt.resolvedUrl("EditCoverPage.qml"))

            Label
            {
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: actionName
            }
        }
    }
}
