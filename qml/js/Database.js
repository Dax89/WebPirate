.pragma library

.import QtQuick.LocalStorage 2.0 as Storage

function instance()
{
    return openDatabase("1.1");
}

function checkDBUpgrade()
{
    var db = openDatabase("")

    if(db.version === "1.0")
    {
        /* Drop Old "Preview" Database */
        db.changeVersion("1.0", "1.1",
                         function(tx) {
                             tx.executeSql("DROP TABLE IF EXISTS BrowserSettings");
                             tx.executeSql("DROP TABLE IF EXISTS Favorites");
                             tx.executeSql("DROP TABLE IF EXISTS SearchEngines");
                         });
    }
}

function openDatabase(version)
{
    return Storage.LocalStorage.openDatabaseSync("WebPirate", version, "WebPirate Configuration", 5000000);  /* DB Size: 5MB */
}

function set(setting, value)
{
    var db = instance();

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO BrowserSettings (name, value) VALUES (?, ?);", [setting, value]);
    });
}

function get(setting)
{
    var db = instance();
    var res = false;

    db.readTransaction(function(tx) {
        var r = tx.executeSql("SELECT value FROM BrowserSettings WHERE name = ?;", [setting]);

        if(r.rows.length > 0)
            res = r.rows.item(0).value;
    });

    return res;
}

function load()
{
    checkDBUpgrade();
    var db = instance();

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS BrowserSettings(name TEXT PRIMARY KEY, value TEXT)");
    });
}

function save(homepage, searchengine, useragent)
{
    set("homepage", homepage);
    set("searchengine", searchengine);
    set("useragent", useragent);
}
