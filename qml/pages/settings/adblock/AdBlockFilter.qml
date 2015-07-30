import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.webpirate.AdBlock 1.0

Dialog
{
    property int index: -1
    property AdBlockEditor adblockeditor

    id: dlgadblockfilter
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: tffilter.text.length > 0

    onAccepted: {
        if(index === -1)
            adblockeditor.addFilter(tffilter.text);
        else
            adblockeditor.setFilter(index, tffilter.text);
    }

    Component.onCompleted: {
        if(index !== -1)
            tffilter.text = adblockeditor.filter(index);
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            DialogHeader
            {
                acceptText: qsTr("Save")
            }

            TextField
            {
                id: tffilter
                placeholderText: qsTr("Filter")
                width: parent.width
            }
        }
    }
}
