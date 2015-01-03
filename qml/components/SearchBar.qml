import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/SearchEngines.js" as SearchEngines

Item
{
    id: searchbar

    property string title
    property string url

    signal textChanged(string text)
    signal returnPressed(string searchquery)

    TextField
    {
        id: searchfield
        anchors { left: parent.left; right: parent.right }
        font.pixelSize: Theme.fontSizeSmall
        inputMethodHints: Qt.ImhNoAutoUppercase
        placeholderText: qsTr("Search with") + " " + mainwindow.settings.searchengines.get(mainwindow.settings.searchengine).name
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

        onTextChanged: searchbar.textChanged(text)
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
