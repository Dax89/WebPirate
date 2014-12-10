import QtQuick 2.0

QtObject
{
    property FavoritesModel favorites: FavoritesModel { }
    property ListModel searchengines: ListModel { }
    property ListModel useragents: ListModel { }

    property var searchengine;  /* JSON Format of the Selected Search Engine */
    property int useragent;     /* User Agent Index */
    property string homepage;   /* HomePage Url */
}
