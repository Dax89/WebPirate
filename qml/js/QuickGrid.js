.pragma library

function load(db, quickgridmodel)
{
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS QuickGrid (id INTEGER PRIMARY KEY, title TEXT, url TEXT)");
        var res = tx.executeSql("SELECT title, url FROM QuickGrid");

        for(var i = 0; i < res.rows.length; i++)
            quickgridmodel.append({ "special": false, "title": res.rows[i].title ? res.rows[i].title : "", "url": res.rows[i].url ? res.rows[i].url : "" });
    });

    quickgridmodel.append({ "special": true, "title": "", "url": "" });
}

function save(db, quickgridmodel)
{
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM QuickGrid");

        for(var i = 0; i < quickgridmodel.count - 1; i++) {
            var item = quickgridmodel.get(i);
            tx.executeSql("INSERT INTO QuickGrid (id, title, url) VALUES (?, ?, ?)", [i, item.title, item.url]);
        }
    });
}
