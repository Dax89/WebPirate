import QtQuick 2.1
import Sailfish.Silica 1.0

Dialog
{
    property string elementId
    property int maxLength

    property alias text: textarea.text
    property alias selectionStart: textarea.selectionStart
    property alias selectionEnd: textarea.selectionEnd

    id: dlgtextfield
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    onStatusChanged: {
        if(status !== PageStatus.Active)
            return;

        textarea.forceActiveFocus();
    }

    SilicaFlickable
    {
        anchors.fill: parent

        DialogHeader
        {
            id: dlgheader
            acceptText: qsTr("Send")
        }

        TextArea
        {
            property string previousText

            id: textarea
            anchors { left: parent.left; top: dlgheader.bottom; right: parent.right; bottom: parent.bottom }

            onTextChanged: {
                if(dlgtextfield.maxLength <= -1)
                    return;

                if(text.length > dlgtextfield.maxLength) {
                    var cursor = cursorPosition;
                    text = previousText;

                    if(cursor > dlgtextfield.maxLength)
                        cursorPosition = text.length;
                    else
                        cursorPosition = text.length - 1;
                }

                previousText = text;
            }
        }
    }
}
