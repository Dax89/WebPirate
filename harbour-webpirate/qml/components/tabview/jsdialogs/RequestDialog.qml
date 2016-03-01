import QtQuick 2.1
import Sailfish.Silica 1.0

JavaScriptDialog
{
    id: requestdialog

    Row
    {
        parent: requestdialog.contentItem
        width: parent.width
        spacing: Theme.paddingSmall

        Button
        {
            id: lblyes
            width: (parent.width / 2) - Theme.paddingSmall
            text: qsTr("Yes")
            onClicked: accept()
        }

        Button
        {
            id: lblno
            width: parent.width / 2
            text: qsTr("No")
            onClicked: reject()
        }
    }
}
