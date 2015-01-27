import QtQuick 2.1
import Sailfish.Silica 1.0
import "../js/SearchEngines.js" as SearchEngines

Item
{
    property string title
    property string url

    property alias editing: searchfield.focus

    signal textChanged(string text)
    signal returnPressed(string searchquery)

    function triggerKeyboard() {
        searchfield.forceActiveFocus();
    }

    function clear() {
        searchfield.text = "";
    }

    id: searchbar
    height: searchfield.height

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
                sidebar.collapse();
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
