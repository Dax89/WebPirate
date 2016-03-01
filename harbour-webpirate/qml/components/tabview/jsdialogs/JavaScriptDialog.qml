import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../"

DialogBackground
{
    property var model
    property alias title: lbltitle.text
    property bool accepted: false
    property alias contentItem: content

    id: javascriptdialog
    height: content.height + Theme.paddingSmall

    function accept() {
        javascriptdialog.accepted = true;

        if(model)
            model.accept();

        visible = false;
    }

    function reject() {
        if(javascriptdialog.accepted)
            return;

        if(model)
            model.reject();

        visible = false;
    }

    onVisibleChanged: {
        if(visible)
            return;

        reject();
    }

    Column
    {
        id: content
        anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }

        Label
        {
            id: lbltitle
            width: parent.width
            height: text.length > 0 ? Theme.itemSizeSmall : 0
            color: Theme.secondaryHighlightColor
            font.family: Theme.fontFamilyHeading
            font.pixelSize: Theme.fontSizeSmall
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
