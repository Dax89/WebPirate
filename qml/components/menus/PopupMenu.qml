import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property alias title: lblheader.text
    property alias model: listview.model
    property alias delegate: listview.delegate

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
        height = listview.contentHeight + maheader.height;
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
        }
    }
}
