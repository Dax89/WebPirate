.pragma library

function createSchema(db)
{
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS History (url TEXT PRIMARY KEY, title TEXT, lastvisit DATETIME)");

        tx.executeSql("CREATE TRIGGER IF NOT EXISTS delete_till_100 INSERT ON History WHEN (SELECT COUNT(*) FROM History) > 100 \
                       BEGIN \
                         DELETE FROM History WHERE 'url' NOT IN \
                         ( \
                           SELECT url FROM History ORDER BY lastvisit DESC LIMIT 100 \
                         ); \
                       END");
    });
}

function clear(db)
{
    db.transaction(function(tx) {
        tx.executeSql("DROP TRIGGER IF EXISTS delete_till_100");
        tx.executeSql("DROP TABLE IF EXISTS History");
    });

    createSchema(db);
}

function store(db, url, title)
{
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO History(url, title, lastvisit) VALUES(?, ?, DATETIME('now'))", [url, title]);
    });
}

function match(db, query, model)
{
    model.clear();

    if(query.length < 2)
        return;

    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM History WHERE url LIKE '%" + query + "%' OR title LIKE '%" + query + "%' ORDER BY lastvisit DESC LIMIT 10");

        for(var i = 0; i < res.rows.length; i++)
            model.append(res.rows[i]);
    });
}
