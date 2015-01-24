import QtQuick 2.0
import QtSystemInfo 5.0
import WebPirate 1.0
import "cover"

QtObject
{
    property DeviceInfo deviceinfo: DeviceInfo { }
    property SearchEngineModel searchengines: SearchEngineModel { }
    property DownloadManager downloadmanager: DownloadManager { }
    property QuickGridModel quickgridmodel: QuickGridModel { }
    property WebIconDatabase icondatabase: WebIconDatabase { }
    property CoverModel coveractions: CoverModel { }

    property int searchengine;  /* Search Engine Index */
    property int useragent;     /* User Agent Index */
    property string homepage;   /* HomePage Url */
    property bool clearonexit;  /* Wipe UserData on exit */

    readonly property string version: "0.8.6"
}
