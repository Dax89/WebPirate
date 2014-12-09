import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    property alias message: lblmessage.text

    id: confirmdialog
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    SilicaFlickable
    {
        anchors.fill: parent

        Column
        {
            anchors.fill: parent

            DialogHeader
            {
                id: dlgheader
                title: qsTr("Yes");
            }

            Label
            {
                id: lblmessage
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
    }
}
