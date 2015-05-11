import QtQuick 2.1
import QtWebKit 3.0
import Sailfish.Silica 1.0
import ".."

BrowserBar
{
    property alias findError: searchfield.errorHighlight

    id: searchbar

    onSolidified: {
        searchbar.findError = false;
    }

    Row
    {
        anchors.fill: parent

        SearchField
        {
            id: searchfield
            width: parent.width - (btnsearchup.width + btnsearchdown.width + btnclose.width)
            height: parent.height
            font.pixelSize: Theme.fontSizeSmall
            inputMethodHints: Qt.ImhNoAutoUppercase
            placeholderText: qsTr("Search") + "..."

            onTextChanged: {
                searchfield.errorHighlight = false;
            }
        }

        IconButton
        {
            id: btnsearchup
            icon.source: "image://theme/icon-m-enter-close"
            enabled: searchfield.text.length > 0
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.itemSizeExtraSmall
            rotation: 180

            onClicked: webview.experimental.findText(searchfield.text, 0xE); /* WebViewExperimental.FindBackward |
                                                                                WebViewExperimental.FindHighlightAllOccurrences |
                                                                                WebViewExperimental.FindWrapsAroundDocument */
        }

        IconButton
        {
            id: btnsearchdown
            icon.source: "image://theme/icon-m-enter-close"
            enabled: searchfield.text.length > 0
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.itemSizeExtraSmall

            onClicked: webview.experimental.findText(searchfield.text, 0xC); /* WebViewExperimental.FindHighlightAllOccurrences |
                                                                                WebViewExperimental.FindWrapsAroundDocument */
        }

        IconButton
        {
            id: btnclose
            icon.source: "image://theme/icon-close-app"
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.itemSizeExtraSmall

            onClicked: {
                webview.experimental.findText("", 0);
                searchbar.evaporate();
            }
        }
    }
}
