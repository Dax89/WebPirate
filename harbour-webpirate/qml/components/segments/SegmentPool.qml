import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"

Item
{
    property Settings settings
    property var tabView

    property Component tabsSegmentComponent: Component { TabsSegment { } }
    property Component closedTabsComponent: Component { ClosedTabsSegment { } }
    property Component favoritesComponent: Component { FavoritesSegment { } }
    property Component downloadsComponent: Component { DownloadsSegment { } }
    property Component sessionsComponent: Component { SessionsSegment { } }
    property Component cookiesComponent: Component { CookiesSegment { } }
    property Component historyComponent: Component { HistorySegment { } }
}
