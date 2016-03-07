import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components/tabview"
import "../../components/segments"

Page
{
    property int currentSegment: segmentsmodel.tabsSegment
    property Settings settings
    property TabView tabView

    id: segmentspage
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        loader.setSource(Qt.resolvedUrl("../../components/segments/TabsSegment.qml")); // Tabs by default
    }

    onCurrentSegmentChanged: {
        if(currentSegment === segmentsmodel.tabsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/TabsSegment.qml"));
        else if(currentSegment === segmentsmodel.closedTabsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/ClosedTabsSegment.qml"));
        else if(currentSegment === segmentsmodel.favoritesSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/FavoritesSegment.qml"));
        else if(currentSegment === segmentsmodel.downloadsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/DownloadsSegment.qml"));
        else if(currentSegment === segmentsmodel.sessionsSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/SessionsSegment.qml"));
        else if(currentSegment === segmentsmodel.historySegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/HistorySegment.qml"));
        else if(currentSegment === segmentsmodel.cookieSegment)
            loader.setSource(Qt.resolvedUrl("../../components/segments/CookiesSegment.qml"));
        else
            loader.sourceComponent = null;
    }

    SegmentsModel { id: segmentsmodel }

    Item
    {
        anchors.fill: parent

        Loader
        {
            id: loader
            asynchronous: true
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: bottompanel.top }

            onItemChanged: {
                if(!loader.item)
                    return;

                loader.item.load();
            }
        }

        PanelBackground
        {
            readonly property real itemWidth: bottompanel.width / 5

            id: bottompanel
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
            height: (segmentspage.isPortrait ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall) + Theme.paddingSmall

            SilicaListView
            {
                id: lvsections
                anchors { left: parent.left; bottom: selectionrect.bottom; right: parent.right }
                height: bottompanel.height
                clip: true
                orientation: ListView.Horizontal
                currentIndex: 0
                model: segmentsmodel.elements

                delegate: ListItem {
                    width: bottompanel.itemWidth
                    contentHeight: bottompanel.height

                    onClicked: {
                        if(loader.item)
                            loader.item.unload();

                        segmentspage.currentSegment = model.segment;
                        lvsections.currentIndex = model.index;
                    }

                    Image {
                        id: img
                        source: model.icon
                        width: Theme.iconSizeMedium
                        height: Theme.iconSizeMedium
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        anchors.centerIn: parent
                    }
                }
            }

            Rectangle
            {
                Behavior on x {
                    NumberAnimation { duration: lvsections.moving ? 0 : 100; easing.type: Easing.Linear }
                }

                id: selectionrect
                x: lvsections.currentItem ? (lvsections.currentItem.x - lvsections.contentX) : 0
                anchors.bottom: parent.bottom
                height: Theme.paddingSmall
                width: bottompanel.itemWidth
                color: Theme.highlightColor
            }
        }
    }
}
