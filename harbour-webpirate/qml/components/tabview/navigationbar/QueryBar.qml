import QtQuick 2.1
import Sailfish.Silica 1.0

SearchField
{
    property alias findError: querybar.errorHighlight
    property alias editing: querybar.focus
    property bool searchMode: false
    property bool displayingText: false
    property string title
    property string url

    signal returnPressed(string searchquery)
    signal searchPressed(string searchquery)

    function displayText() {
        if(searchMode)
            return;

        displayingText = true;

        if(focus || title.length == 0) {
            querybar.text = url;
            displayingText = false;
            return;
        }

        querybar.text = title;
        displayingText = false;
    }

    function updateSelection() {
        if(focus) {
            selectAll();
            return;
        }

        deselect();
    }

    id: querybar
    font.pixelSize: Theme.fontSizeSmall
    focusOutBehavior: FocusBehavior.ClearItemFocus
    textLeftMargin: Theme.paddingMedium
    textRightMargin: Theme.paddingMedium
    labelVisible: false
    background: null

    inputMethodHints: {
        var imh = Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;

        if(!searchMode)
            imh |= Qt.ImhUrlCharactersOnly;

        return imh;
    }

    placeholderText: {
        if(searchMode)
            return qsTr("Search...");

        return qsTr("Search with") + " " + mainwindow.settings.searchengines.get(mainwindow.settings.searchengine).name;
    }

    EnterKey.iconSource: {
        if(searchMode)
            return "image://theme/icon-m-search";

        return "image://theme/icon-m-enter-accept";
    }

    EnterKey.onClicked: {
        if(searchMode)
            querybar.searchPressed(text);
        else
            querybar.returnPressed(text);

        querybar.focus = false;
    }

    onUrlChanged: displayText()
    onTitleChanged: displayText()

    onTextChanged: {
        querybar.errorHighlight = false;
    }

    onSearchModeChanged: {
        if(!searchMode) {
            displayText();
            return;
        }

        querybar.text = "";
    }

    onFocusChanged: {
        displayText();
        updateSelection();
    }
}
