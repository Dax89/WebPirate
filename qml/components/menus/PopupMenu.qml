import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property alias title: lblheader.text
    property alias popupModel: listview.model
    property alias popupDelegate: listview.delegate

    property bool titleVisible: true

    id: popupmenu
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    visible: false
    z: 10

    Behavior on height {
        NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightDimmerColor, 1.0) }
        GradientStop { position: 1.0; color: Theme.rgba(Theme.highlightDimmerColor, 0.9) }
    }

    onHeightChanged: visible = (height > 0 ? true : false);

    function show() {
        height = (Theme.itemSizeSmall * Math.min(3, listview.count)) + (titleVisible ? maheader.height : 0);
    }

    function hide() {
        height = 0;
    }

    Column
    {
        anchors.fill: parent

        MouseArea
        {
            id: maheader
            width: parent.width
            height: Theme.itemSizeSmall
            visible: titleVisible

            Label
            {
                id: lblheader
                anchors.fill: parent
                color: Theme.secondaryHighlightColor
                clip: true
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            onClicked: popupmenu.hide()
        }

        SilicaListView
        {
            id: listview
            width: parent.width
            height: parent.height
            clip: true

            VerticalScrollDecorator { flickable: listview }
        }
    }
}
