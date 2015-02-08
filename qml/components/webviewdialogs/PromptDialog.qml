import QtQuick 2.1
import Sailfish.Silica 1.0

Dialog
{
    property var promptModel
    property alias title: lbltitle.text
    property alias textField: tfprompt.text

    id: promptdialog
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true
    onAccepted: promptModel.accept(tfprompt.text)
    onRejected: promptModel.reject()

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            DialogHeader { acceptText: qsTr("OK") }

            Label
            {
                id: lbltitle
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Theme.highlightColor
            }

            TextField
            {
                id: tfprompt
                width: parent.width
            }
        }
    }
}
