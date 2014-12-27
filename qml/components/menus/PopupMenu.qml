import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea
{
    property alias title: lblheader.text
    property alias popupModel: listview.model
    property alias popupDelegate: listview.delegate

    property bool titleVisible: true

    function show() {
        mousearea.visible = true;
        popupmenu.height = (Theme.itemSizeSmall * Math.min(3, listview.count)) + (titleVisible ? lblheader.height : 0);
    }

    function hide() {
        mousearea.visible = false;
        popupmenu.height = 0;
    }

    id: mousearea
    visible: false
    z: 10
    onClicked: hide()

    Rectangle
    {
        id: popupmenu
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Behavior on height {
            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
            GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.9) }
        }

        onHeightChanged: visible = (height > 0 ? true : false)

        Label
        {
            id: lblheader
            width: parent.width
            height: Theme.itemSizeSmall
            color: Theme.secondaryHighlightColor
            font.family: Theme.fontFamilyHeading
            font.pixelSize: Theme.fontSizeSmall
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: titleVisible
            clip: true
        }

        SilicaListView
        {
            id: listview
            clip: true

            anchors
            {
                left: parent.left
                top: lblheader.bottom
                right: parent.right
                bottom: parent.bottom
            }

            VerticalScrollDecorator { flickable: listview }
        }
    }
}
