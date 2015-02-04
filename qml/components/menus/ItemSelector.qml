import QtQuick 2.1
import Sailfish.Silica 1.0

PopupMenu
{
    property QtObject selectorModel
    property bool accepted: false

    QtObject
    {
        property bool navigationWasVisible: true
        id: itemselectorprivate
    }

    id: itemselector
    visible: true
    titleVisible: false
    onClicked: selectorModel.reject();
    width: Screen.width
    height: Screen.height - tabheader.height

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
        itemselectorprivate.navigationWasVisible = navigationbar.visible;
        navigationbar.evaporate();

        itemselector.accepted = false
        itemselector.show();
    }

    Component.onDestruction: {
        if(itemselectorprivate.navigationWasVisible)
            navigationbar.solidify();
    }
}
