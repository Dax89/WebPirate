import QtQuick 2.1
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import Sailfish.Silica 1.0

BrowserBar
{
    property alias findError: searchfield.errorHighlight

    id: findtextbar

    onSolidified: {
        findtextbar.findError = false;
    }

    onEvaporated: {
        searchfield.text = "";
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
            placeholderText: qsTr("Insert text") + "..."

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

            onClicked: webview.experimental.findText(searchfield.text, WebViewExperimental.FindBackward |
                                                                       WebViewExperimental.FindHighlightAllOccurrences |
                                                                       WebViewExperimental.FindWrapsAroundDocument);
        }

        IconButton
        {
            id: btnsearchdown
            icon.source: "image://theme/icon-m-enter-close"
            enabled: searchfield.text.length > 0
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.itemSizeExtraSmall

            onClicked: webview.experimental.findText(searchfield.text, WebViewExperimental.FindHighlightAllOccurrences |
                                                                       WebViewExperimental.FindWrapsAroundDocument)
        }

        IconButton
        {
            id: btnclose
            icon.source: "image://theme/icon-close-app"
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.itemSizeExtraSmall

            onClicked: {
                webview.experimental.findText("", 0);
                findtextbar.evaporate();
            }
        }
    }
}
