import QtQuick 2.1
import Sailfish.Silica 1.0

MouseArea
{
    property alias icon: tabicon.icon
    property alias title: tabtitle.text
    property bool loading: false

    function getColor() {
        if(pressed && containsMouse)
            return Theme.highlightColor;

        return (index === tabview.currentIndex ? Theme.secondaryColor : Theme.secondaryHighlightColor);
    }

    onPressAndHold: {
        sidebar.collapse();

        tabmenu.selectedIndex = index;
        tabmenu.show();
    }

    onClicked: {
        sidebar.collapse();
        tabview.currentIndex = index;
    }

    Rectangle
    {
        id: tabbutton
        radius: 8
        anchors { fill: parent; topMargin: tabbutton.radius / 4; bottomMargin: -tabbutton.radius }
        color: getColor()

        Item /* Needed in order to align | Icon | Text | X | button correctly */
        {
            anchors { fill: parent; topMargin: tabbutton.radius / 4; bottomMargin: tabbutton.radius }

            TabIcon
            {
                id: tabicon
                size: tabtitle.contentHeight
                radius: tabbutton.radius
                width: visible ? parent.height : 0
                height: parent.height
                anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                busy: loading
            }

            Text
            {
                id: tabtitle
                anchors { left: tabicon.right; right: closebutton.left; verticalCenter: parent.verticalCenter }
                font.pixelSize: Theme.fontSizeSmall
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            TabCloseButton
            {
                id: closebutton
                radius: tabbutton.radius
                width: visible ? parent.height : 0
                height: parent.height
                anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: visible ? 0 : Theme.paddingMedium }
                visible: (tabs.count > 1) || mainwindow.settings.closelasttab
                onClicked: tabview.removeTab(index)
            }
        }
    }
}
