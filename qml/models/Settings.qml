import QtQuick 2.1
import WebPirate 1.0
import WebPirate.Private 1.0
import WebPirate.DBus 1.0
import WebPirate.DBus.TransferEngine 1.0
import WebPirate.AdBlock 1.0
import "cover"

QtObject
{
    property MimeDatabase mimedatabase: MimeDatabase { }
    property ScreenBlank screenblank: ScreenBlank { }
    property SearchEngineModel searchengines: SearchEngineModel { }
    property DownloadManager downloadmanager: DownloadManager { }
    property AdBlockManager adblockmanager: AdBlockManager { }
    property QuickGridModel quickgridmodel: QuickGridModel { }
    property CookieJar cookiejar: CookieJar { }
    property WebKitDatabase webkitdatabase: WebKitDatabase { }
    property WebIconDatabase icondatabase: WebIconDatabase { }
    property TransferEngine transferengine: TransferEngine { }
    property UrlComposer urlcomposer: UrlComposer { }
    property CoverModel coveractions: CoverModel { }

    property int searchengine        /* Search Engine Index */
    property int useragent           /* User Agent Index */
    property string homepage         /* HomePage Url */
    property bool clearonexit        /* Wipe UserData on exit */
    property bool restoretabs        /* Restore Tabs at Startup */
    property bool nightmode: false;  /* Night Mode */

    readonly property string version: "1.0"
}
