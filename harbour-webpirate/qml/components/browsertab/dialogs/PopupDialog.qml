import QtQuick 2.1
import Sailfish.Silica 1.0

MouseArea
{
    property alias title: lblheader.text
    property alias popupModel: listview.model
    property alias popupDelegate: listview.delegate
    property alias popupList: listview

    property int popupCount: listview.count
    property bool titleVisible: true

    signal ignoreDialog()

    function show() {
        popupdialog.visible = true;
    }

    function hide() {
        popupdialog.visible = false;
    }

    id: popupdialog
    visible: false
    z: 20

    onClicked: {
        ignoreDialog();
        hide()
    }

    onTitleVisibleChanged: {
        lblheader.visible = titleVisible;
    }

    Rectangle
    {
        id: popupmenu
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: visible ? (Theme.itemSizeSmall * Math.min(5, popupCount)) + (titleVisible ? Theme.itemSizeSmall : 0) : 0

        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
            GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.9) }
        }

        Behavior on height {
            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
        }

        Label
        {
            id: lblheader
            width: parent.width
            height: visible ? Theme.itemSizeSmall : 0;
            color: Theme.secondaryHighlightColor
            font.family: Theme.fontFamilyHeading
            font.pixelSize: Theme.fontSizeSmall
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            clip: true
        }

        SilicaListView
        {
            id: listview
            anchors { left: parent.left; top: lblheader.bottom; right: parent.right; bottom: parent.bottom }
            clip: true

            VerticalScrollDecorator { flickable: listview }
        }
    }
}
