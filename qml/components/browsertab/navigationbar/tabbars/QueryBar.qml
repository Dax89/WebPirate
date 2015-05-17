import QtQuick 2.1
import Sailfish.Silica 1.0

Item
{
    property string title
    property string url

    property alias editing: queryfield.focus

    signal textChanged(string text)
    signal returnPressed(string searchquery)

    function triggerKeyboard() {
        queryfield.forceActiveFocus();
    }

    function clear() {
        queryfield.text = "";
    }

    id: querybar
    height: queryfield.height

    Behavior on width {
        NumberAnimation { duration: 500; easing.type: Easing.InOutElastic }
    }

    TextField
    {
        id: queryfield
        anchors { left: parent.left; right: parent.right }
        font.pixelSize: Theme.fontSizeSmall
        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
        placeholderText: qsTr("Search with") + " " + mainwindow.settings.searchengines.get(mainwindow.settings.searchengine).name
        labelVisible: false

        Keys.onReturnPressed: {
            querybar.returnPressed(text);
            queryfield.focus = false;
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

        onTextChanged: querybar.textChanged(text)
    }

    onUrlChanged: {
        if(!queryfield.focus)
            queryfield.text = (title.length == 0 ? url : title);
    }

    onTitleChanged: {
        if(!queryfield.focus)
            queryfield.text = title
    }
}
