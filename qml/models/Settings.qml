import QtQuick 2.0
import QtSystemInfo 5.0
import WebPirate 1.0

QtObject
{
    property DeviceInfo deviceinfo: DeviceInfo { }
    property SearchEngineModel searchengines: SearchEngineModel { }
    property ListModel useragents: ListModel { }
    property DownloadManager downloadmanager: DownloadManager { }
    property WebIconDatabase icondatabase: WebIconDatabase { }

    property int searchengine;  /* Search Engine Index */
    property int useragent;     /* User Agent Index */
    property string homepage;   /* HomePage Url */
    property bool clearonexit;  /* Wipe UserData on exit */
}
