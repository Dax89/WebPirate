import QtQuick 2.1
import Sailfish.Silica 1.0

WebViewDialog
{
    property QtObject selectorModel

    id: itemselector
    visible: true
    titleVisible: false
    width: Screen.width
    height: Screen.height - tabheader.height
    onClicked: selectorModel.reject()

    popupDelegate: ListItem {
        contentHeight: Theme.itemSizeSmall
        contentWidth: parent.width
        highlighted: model.selected
        enabled: model.enabled

        Label
        {
            id: lblitemsel
            anchors { left: parent.left; right: itemselswitch.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingLarge }
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            elide: Text.ElideRight
            text: model.text
        }

        Switch
        {
            id: itemselswitch
            anchors { right: parent.right; verticalCenter: lblitemsel.verticalCenter }
            checked: model.selected
            onClicked: itemselector.selectorModel.accept(model.index)
        }

        onClicked: itemselector.selectorModel.accept(model.index)
    }

    onSelectorModelChanged: {
        itemselector.popupModel = itemselector.selectorModel.items;
    }

    Component.onCompleted: popupList.positionViewAtIndex(webview.itemSelectorIndex, ListView.Beginning)
}
