.pragma library

.import QtQuick.LocalStorage 2.0 as Storage

function instance()
{
    return Storage.LocalStorage.openDatabaseSync("WebPirate", "1.0", "UserSettings", 100000);
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

    db.transaction(function(tx) {
        var r = tx.executeSql("SELECT value FROM BrowserSettings WHERE name = ?;", [setting]);

        if(r.rows.length > 0)
            res = r.rows.item(0).value;
    });

    return res;
}

function load()
{
    var db = instance();

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS BrowserSettings(name TEXT PRIMARY KEY, value TEXT)");
    });
}

function save(homepage, searchengine, useragent)
{
    set("homepage", homepage);
    set("useragent", useragent);
    set("searchengine", JSON.stringify(searchengine));
}
