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

    function executeClick() {
        sidebar.collapse();
        tabview.currentIndex = index;
    }

    Timer
    {
        id: timdoubletap
        interval: 150
        onTriggered: executeClick()
    }

    onClicked: {
        if(!timdoubletap.running) {
            timdoubletap.start();
            return;
        }

        /* Handle Double Tap */
        if(tabs.count > 1)
            tabview.removeTab(index);
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
                anchors { left: indicator.right; right: btnclose.left; verticalCenter: parent.verticalCenter; leftMargin: Theme.paddingSmall }
                font.pixelSize: Theme.fontSizeSmall
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            IconButton
            {
                id: btnclose
                width: Theme.iconSizeSmall
                height: Theme.iconSizeSmall
                anchors { right: parent.right; rightMargin: Theme.paddingSmall; verticalCenter: parent.verticalCenter }
                icon.source: "image://theme/icon-close-vkb"
                visible: tabs.count > 1
                onClicked: tabview.removeTab(index)
            }
        }
    }
}
