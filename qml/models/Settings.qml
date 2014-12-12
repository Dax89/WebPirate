import QtQuick 2.0

QtObject
{
    property FavoritesModel favorites: FavoritesModel { }
    property SearchEngineModel searchengines: SearchEngineModel { }
    property ListModel useragents: ListModel { }

    property int searchengine;  /* Search Engine Index */
    property int useragent;     /* User Agent Index */
    property string homepage;   /* HomePage Url */
    property bool clearonexit;  /* Wipe UserData on exit */
}
