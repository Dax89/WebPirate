.pragma library

function load(db, quickgridmodel, maxitems)
{
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS QuickGrid (id INTEGER PRIMARY KEY, title TEXT, url TEXT)");

        for(var i = 0; i < maxitems; i++)
        {
            var res = tx.executeSql("SELECT title, url FROM QuickGrid WHERE id = ?", [i]);
            var object = new Object;

            if(res.rows.length === 0)
            {
                quickgridmodel.append({ "title": "", "url": "" });
                continue;
            }

            quickgridmodel.append(res.rows[0]);
        }
    });
}

function get(db, id)
{
    var data = null;

    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT title, url FROM QuickGrid WHERE id = ?", [id]);

        if(res.rows.length > 0)
            data = res.rows[0];
    });

    return data;
}

function set(db, id, title, url)
{
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO QuickGrid (id, title, url) VALUES (?, ?, ?)", [id, title, url]);
    });
}
