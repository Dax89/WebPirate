import QtQuick 2.1
import Sailfish.Silica 1.0

MouseArea
{
    property alias icon: favicon.source
    property alias title: tabtitle.text
    property bool loading: false

    function getColor() {
        if(pressed && containsMouse)
            return Theme.highlightColor;

        return (index === tabview.currentIndex ? Theme.secondaryColor : Theme.secondaryHighlightColor);
    }

    onClicked: {
        sidebar.collapse();
        tabview.currentIndex = index;
    }

    onPressAndHold: {
        sidebar.collapse();

        tabmenu.selectedIndex = index;
        tabmenu.show();
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

            Item
            {
                id: indicator
                width: tabtitle.contentHeight
                height: tabtitle.contentHeight
                anchors { left: parent.left; leftMargin: Theme.paddingSmall; verticalCenter: parent.verticalCenter }

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
                anchors { left: indicator.right; right: closebutton.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingSmall }
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
                anchors { right: parent.right; top: parent.top; bottom: parent.bottom; rightMargin: visible ? 0 : Theme.paddingSmall }
                visible: tabs.count > 1
                onClicked: tabview.removeTab(index)
            }
        }
    }
}
