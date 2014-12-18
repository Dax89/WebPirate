import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea
{
    id: itemselector
    property QtObject selectorModel: model
    property bool accepted: false

    anchors.fill: parent
    onClicked: selectorModel.reject();

    PopupMenu
    {
        id: selectorpopup
        visible: true
        titleVisible: false
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

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
    }

    onSelectorModelChanged: {
        selectorpopup.popupModel = itemselector.selectorModel.items;
    }

    Component.onCompleted: {
        itemselector.accepted = false
        selectorpopup.show();
    }
}
