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

        Label {
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: model.selected ? Theme.highlightColor : Theme.primaryColor
            text: model.text
        }

        onClicked: itemselector.selectorModel.accept(model.index)
    }

    onSelectorModelChanged: {
        itemselector.popupModel = itemselector.selectorModel.items;
    }

    Component.onCompleted: popupList.positionViewAtIndex(webview.itemSelectorIndex, ListView.Beginning)
}
