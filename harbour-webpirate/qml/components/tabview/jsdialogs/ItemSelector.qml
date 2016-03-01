import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../"

SilicaListView
{
    property var tab
    property QtObject selectorModel

    DialogBackground {
        anchors.fill: parent
    }

    id: itemselector
    visible: false
    clip: true

    delegate: ListItem {
        contentWidth: parent.width
        contentHeight: Theme.itemSizeSmall
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
        itemselector.model = (itemselector.selectorModel ? itemselector.selectorModel.items : null);
    }

    onVisibleChanged: {
        if(visible || !itemselector.selectorModel) {

            if(visible && tab)
                positionViewAtIndex(tab.webView.itemSelectorIndex, ListView.Beginning);

            return;
        }

        itemselector.selectorModel.reject();
        itemselector.selectorModel = null;
    }
}
