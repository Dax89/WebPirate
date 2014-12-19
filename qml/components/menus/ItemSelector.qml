import QtQuick 2.0
import Sailfish.Silica 1.0

PopupMenu
{
    property QtObject selectorModel: model
    property bool accepted: false

    id: itemselector
    visible: true
    titleVisible: false
    onClicked: selectorModel.reject();

    popupDelegate: ListItem {
        highlighted: model.selected
        enabled: model.enabled

        Label {
            anchors.fill: parent
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: model.text
        }

        onClicked: {
            itemselector.accepted = true;
            itemselector.selectorModel.accept(model.index);
        }
    }

    onSelectorModelChanged: {
        itemselector.popupModel = itemselector.selectorModel.items;
    }

    Component.onCompleted: {
        itemselector.accepted = false
        itemselector.show();
    }
}
