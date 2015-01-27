import QtQuick 2.1
import Sailfish.Silica 1.0

Rectangle
{
    property alias icon: favicon.source
    property alias title: tabtitle.text
    property bool loading: false

    id: tabbutton
    anchors { top: headerrow.top; bottom: headerrow.bottom }
    width: tabheader.tabWidth
    color: (index === currentIndex ? Theme.secondaryColor : Theme.secondaryHighlightColor);

    Behavior on width {
        NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
    }

    MouseArea
    {
        id: headermousearea
        anchors { left: parent.left; top: parent.top; right: btnclose.left; bottom: parent.bottom }

        Item
        {
            id: indicator
            anchors { left: parent.left; leftMargin: Theme.paddingSmall; verticalCenter: parent.verticalCenter }
            width: tabtitle.height
            height: tabtitle.height

            BusyIndicator
            {
                id: loadindicator
                visible: loading
                running: loading
                anchors.fill: parent
                size: BusyIndicatorSize.Small
            }

            Image
            {
                id: favicon
                visible: !loading
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
            }
        }

        Text
        {
            id: tabtitle
            anchors { left: indicator.right; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingSmall }
            font.pixelSize: Theme.fontSizeSmall
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            maximumLineCount: 1
            clip: true
        }

        onClicked: {
            sidebar.collapse();
            tabview.currentIndex = index;
        }
    }

    IconButton
    {
        id: btnclose
        width: Theme.iconSizeSmall
        height: Theme.iconSizeSmall
        anchors { right: parent.right; rightMargin: Theme.paddingSmall; verticalCenter: headermousearea.verticalCenter }
        icon.source: "image://theme/icon-close-vkb"
        visible: pages.count > 1
        onClicked: tabview.removeTab(index)
    }
}
