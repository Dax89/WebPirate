import QtQuick 2.1
import Sailfish.Silica 1.0

JavaScriptDialog
{
    id: alertdialog
    title: model ? model.message : ""

    Button
    {
        parent: alertdialog.contentItem
        width: parent.width
        text: qsTr("Ok")
        height: Theme.itemSizeSmall
        onClicked: accept()
    }
}
