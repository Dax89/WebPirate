import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components"

Dialog
{
    property alias text: textarea.text

    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    onAccepted: {
        if(!textarea.selectedText.length || (!textarea.selectionStart && (textarea.selectionEnd == textarea.text.length)))
            Clipboard.text = textarea.text;
    }

    DialogHeader {
        id: header
        acceptText: qsTr("Copy")
    }

    TextArea
    {
        id: textarea
        softwareInputPanelEnabled: false

        anchors
        {
            left: parent.left
            top: header.bottom
            right: parent.right
            bottom: parent.bottom
        }

        Component.onCompleted: textarea.selectAll();
    }
}
