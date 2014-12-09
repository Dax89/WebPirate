.pragma library

.import QtQuick.LocalStorage 2.0 as Storage
.import "SearchEngines.js" as SearchEngines
.import "Favorites.js" as Favorites

var useragents = [ {"type": "Mobile", "value": "Mozilla/5.0 (Maemo; Linux; U; Jolla; Sailfish; Mobile; rv:26.0) Gecko/26.0 Firefox/26.0 SailfishBrowser/1.0 like Safari/538.1"},
                   {"type": "Desktop", "value": "Mozilla/5.0 (X11; U; Linux i686; rv:25.0) Gecko/20100101 Firefox/25.0" } ];

var searchengines;       /*    Saved Search Engines    */
var favorites;           /*      Saved Favorites       */

var defaultsearchengine; /* The Selected Search Engine */
var useragenttype;       /*     Favorite User Agent    */
var homepage;            /*     Current Home Page      */

function getDatabase()
{
    return Storage.LocalStorage.openDatabaseSync("WebPirate", "1.0", "UserSettings", 100000);
}

function setSetting(setting, value)
{
    var db = getDatabase();

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO BrowserSettings (name, value) VALUES (?, ?);", [setting, value]);
    });
}

function getSetting(setting)
{
    var db = getDatabase();
    var res = false;

    db.transaction(function(tx) {
        var r = tx.executeSql("SELECT value FROM BrowserSettings WHERE name = ?;", [setting]);

        if(r.rows.length > 0)
            res = r.rows.item(0).value;
    });

    return res;
}

function load()
{
    var db = getDatabase();

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS BrowserSettings(name TEXT PRIMARY KEY, value TEXT)");
    });

    searchengines = SearchEngines.load(db);
    favorites = Favorites.load(db);

    loadUserAgent();
    loadHomePage();
    loadDefaultSearchEngine();
}

function loadUserAgent()
{
    var ua = getSetting("useragent");

    if(ua === false)
        useragenttype = 0;
    else
        useragenttype = ua;
}

function loadHomePage()
{
    var hp = getSetting("homepage")

    if(hp === false)
        homepage = "about:bookmarks";
    else
        homepage = hp;
}

function loadDefaultSearchEngine()
{
    var se = getSetting("defaultsearchengine");

    if(se === false)
        defaultsearchengine = searchengines[0];
    else
        defaultsearchengine = JSON.parse(se);
}

function save()
{
    setSetting("useragent", useragenttype);
    setSetting("homepage", homepage);
    setSetting("defaultsearchengine", JSON.stringify(defaultsearchengine));
    SearchEngines.save(getDatabase(), searchengines);
}
