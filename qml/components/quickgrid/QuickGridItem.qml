import QtQuick 2.1
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
        x: quickgriditem.x + quickgridview.spacing - quickgridview.contentX
        y: quickgriditem.y + quickgridview.spacing - quickgridview.contentY
        width: quickgriditem.width - (quickgridview.spacing * 2)
        height: quickgriditem.height - (quickgridview.spacing * 2)

        Behavior on x { enabled: state !== "active"; NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
        Behavior on y { enabled: state !== "active"; NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

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

        Rectangle
        {
            id: thumbnail
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: lbltitle.top }
            radius: 8
            border.width: 1
            border.color: Theme.secondaryColor
            color: Theme.highlightDimmerColor

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
                anchors { left: parent.left; bottom: parent.bottom; leftMargin: Theme.paddingSmall; bottomMargin: Theme.paddingSmall }
                icon.source: "image://theme/icon-m-edit"

                onClicked: pageStack.push(Qt.resolvedUrl("../../pages/QuickGridPage.qml"), { "settings": mainwindow.settings, "index": index, "title": lbltitle.text, "url": itemUrl })
            }

            QuickGridButton
            {
                id: btndelete
                opacity: editMode ? 1.0 : 0.0
                anchors { right: parent.right; bottom: parent.bottom; rightMargin: Theme.paddingSmall; bottomMargin: Theme.paddingSmall }
                icon.source: "image://theme/icon-close-vkb"

                onClicked: {
                    if(!itemTitle && !itemUrl) { /* Do not trigger Remorse Timer if the item is empty */
                        mainwindow.settings.quickgridmodel.remove(index);
                        return;
                    }

                    tabviewremorse.execute(qsTr("Removing item"), function() {
                        mainwindow.settings.quickgridmodel.remove(index);
                    });
                }
            }
        }

        Label
        {
            id: lbltitle
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
            font.pixelSize: Theme.fontSizeExtraSmall
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            clip: true
        }
    }
}
