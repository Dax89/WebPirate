import QtQuick 2.1
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0

Item
{
    property int itemId
    property string itemUrl
    property alias itemTitle: lbltitle.text

    id: quickgriditem
    width: quickgridview.cellWidth
    height: quickgridview.cellHeight

    onItemUrlChanged: {
        imgicon.source = mainwindow.settings.icondatabase.provideIcon(itemUrl);
    }

    Item
    {
        id: container
        parent: mousearea
        x: quickgriditem.x + (Theme.paddingSmall / 2) + quickgridview.spacing - quickgridview.contentX
        y: quickgriditem.y + (Theme.paddingSmall / 2) + quickgridview.spacing - quickgridview.contentY
        width: quickgriditem.width - (quickgridview.spacing * 2) - Theme.paddingSmall
        height: quickgriditem.height - (quickgridview.spacing * 2) - Theme.paddingSmall

        Behavior on x { enabled: !quickgridview.flicking && (state !== "active"); NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
        Behavior on y { enabled: !quickgridview.flicking && (state !== "active"); NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

        transitions: Transition { NumberAnimation { property: "scale"; duration: 200} }

        states: State {
            name: "active"; when: mousearea.currentQuickId === quickgriditem.itemId
            PropertyChanges { target: container; x: mousearea.mouseX - width / 2; y: mousearea.mouseY - height / 2; scale: 0.5; z: 10 }
        }

        SequentialAnimation on rotation {
            NumberAnimation { to:  2; duration: 60 }
            NumberAnimation { to: -2; duration: 120 }
            NumberAnimation { to:  0; duration: 60 }
            running: editMode && (mousearea.currentQuickId !== -1) && (state !== "active")
            loops: Animation.Infinite
            alwaysRunToEnd: true
        }

        PanelBackground
        {
            id: thumbnail
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: lbltitle.top }
            border { width: 1; color: Theme.secondaryHighlightColor }
            z: 2

            Image
            {
                id: imgicon
                width: parent.width * 0.4
                height: width
                cache: false
                asynchronous: true
                smooth: true
                visible: itemUrl.length > 0
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }

            QuickGridButton
            {
                id: btnedit
                opacity: editMode ? 1.0 : 0.0
                anchors { left: parent.left; bottom: parent.bottom; leftMargin: -width / 4; bottomMargin: -height / 4 }
                icon.source: "image://theme/icon-m-edit"

                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/QuickGridPage.qml"), { "settings": mainwindow.settings, "index": index, "title": lbltitle.text, "url": itemUrl })
            }

            QuickGridButton
            {
                id: btndelete
                opacity: editMode ? 1.0 : 0.0
                anchors { right: parent.right; bottom: parent.bottom; rightMargin: -width / 4; bottomMargin: -height / 4 }
                icon.source: "image://theme/icon-close-vkb"

                onClicked: {
                    if(!itemTitle && !itemUrl) { /* Do not trigger Remorse Timer if the item is empty */
                        mainwindow.settings.quickgridmodel.remove(index);
                        return;
                    }

                    remorsepopup.execute(qsTr("Removing item"), function() {
                        mainwindow.settings.quickgridmodel.remove(index);
                    });
                }
            }
        }

        Label
        {
            id: lbltitle
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
            font.pixelSize: Theme.fontSizeTiny
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight

            Rectangle
            {
                anchors.fill: parent
                color: Theme.highlightDimmerColor
                z: -1
            }
        }
    }
}
