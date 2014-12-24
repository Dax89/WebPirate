import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    id: searchbar

    property alias icon: favicon.source
    property string title
    property string url

    signal returnPressed(string searchquery)

    Image
    {
        id: favicon
        anchors.left: searchbar.left
        fillMode: Image.PreserveAspectFit

        onSourceChanged: {
            if(source.toString().length > 0) {
                width = Theme.iconSizeSmall
                height = Theme.iconSizeSmall
            } else {
                width = 0
                height = 0
            }
        }
    }

    // @disable-check M301
    TextField
    {
        id: searchfield
        anchors.left: favicon.right
        anchors.right: searchbar.right
        font.pixelSize: Theme.fontSizeSmall
        inputMethodHints: Qt.ImhNoAutoUppercase
        labelVisible: false

        Keys.onReturnPressed: {
            searchbar.returnPressed(text);
            searchfield.focus = false;
        }

        onFocusChanged: {
            if(focus) {
                text = url;
                selectAll();
                return;
            }

            text = title;
            deselect();
        }
    }

    onUrlChanged: {
        if(!searchfield.focus)
            searchfield.text = (title.length == 0 ? url : title);
    }

    onTitleChanged: {
        if(!searchfield.focus)
            searchfield.text = title
    }
}
