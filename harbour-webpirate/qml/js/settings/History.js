.pragma library

.import QtQuick.LocalStorage 2.0 as Storage
.import "../UrlHelper.js" as UrlHelper

function instance()
{
    return Storage.LocalStorage.openDatabaseSync("History", "1.0", "Navigation History", 5000000);  /* DB Size: 5MB */
}

function load()
{
    var db = instance();

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS History (url TEXT PRIMARY KEY, title TEXT, lastvisit DATETIME)");

        tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_till_100 INSERT ON History WHEN (SELECT COUNT(*) FROM History) > 100 \
                       BEGIN \
                         DELETE FROM History WHERE url IN \
                         ( \
                           SELECT url FROM History ORDER BY lastvisit ASC LIMIT (SELECT COUNT(*) - 100 FROM History) \
                         ); \
                       END");
    });
}

function clear()
{
    instance().transaction(function(tx) {
        tx.executeSql("DROP TRIGGER IF EXISTS delete_till_100");
        tx.executeSql("DROP TABLE IF EXISTS History");
    });

    load();
}

function store(url, title)
{
    instance().transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO History(url, title, lastvisit) VALUES(?, ?, DATETIME(CURRENT_TIMESTAMP, 'localtime'))", [url, title]);
    });
}

function domainVisited(url)
{
    var visited = false;
    var urlquery = "%" + UrlHelper.domainName(url) + "%";

    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM History WHERE url LIKE ? LIMIT 1", [urlquery]);
        visited = res.rows.length > 0;
    });

    return visited;
}

function remove(url)
{
    instance().transaction(function(tx) {
        tx.executeSql("DELETE FROM History WHERE url=?", [url]);
    });
}

function match(query, model, maxcount)
{
    model.clear();

    if(maxcount === undefined)
        maxcount = 100;

    if(query.length < 2)
        return;

    var querywc = "%" + query + "%";

    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM History WHERE url LIKE ? OR title LIKE ? ORDER BY lastvisit DESC LIMIT 10", [querywc, querywc]);

        for(var i = 0; i < res.rows.length; i++) {
            if(model.count > maxcount)
                return;

            model.append(res.rows[i]);
        }
    });
}

function fetchAll(model)
{
    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM HISTORY ORDER BY lastvisit DESC")

        if(res.rows.length)
            model.populate(res.rows);
        else
            model.clear();
    });
}
