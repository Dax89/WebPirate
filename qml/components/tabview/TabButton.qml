import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    property alias icon: favicon.source
    property alias title: tabtitle.text

    id: tabbutton
    anchors { top: parent.top; bottom: parent.bottom }
    width: tabview.tabWidth
    color: (index === currentIndex ? Theme.secondaryColor : Theme.secondaryHighlightColor);

    Behavior on width {
        NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
    }

    MouseArea
    {
        id: headermousearea
        anchors { left: parent.left; top: parent.top; right: btnclose.left; bottom: parent.bottom }

        Image
        {
            id: favicon
            anchors { left: parent.left; leftMargin: Theme.paddingSmall; verticalCenter: parent.verticalCenter }
            width: tabtitle.height
            height: tabtitle.height
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
        }

        Text
        {
            id: tabtitle
            anchors { left: favicon.right; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingSmall }
            font.pixelSize: Theme.fontSizeSmall
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            maximumLineCount: 1
            clip: true
        }

        onClicked: {
            tabview.currentIndex = index;
        }
    }

    IconButton
    {
        id: btnclose
        width: Theme.iconSizeSmall
        height: Theme.iconSizeSmall
        anchors {right: parent.right; rightMargin: Theme.paddingSmall; verticalCenter: headermousearea.verticalCenter }
        icon.source: "image://theme/icon-close-vkb"
        visible: pages.count > 1

        onClicked: tabview.removeTab(index)
    }
}
