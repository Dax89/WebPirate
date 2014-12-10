.pragma library

var defaultuseragents = [ {"type": "Mobile", "value": "Mozilla/5.0 (Maemo; Linux; U; Jolla; Sailfish; Mobile; rv:26.0) Gecko/26.0 Firefox/26.0 SailfishBrowser/1.0 like Safari/538.1"},
                          {"type": "Desktop", "value": "Mozilla/5.0 (X11; U; Linux i686; rv:25.0) Gecko/20100101 Firefox/25.0" } ];

function load(db, useragents)
{
    var i = 0;

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS UserAgents (type TEXT PRIMARY KEY, value TEXT)");
        var res = tx.executeSql("SELECT * FROM UserAgents;");

        if(res.rows.length > 0)
        {
            for(i = 0; i < res.rows.length; i++)
                useragents.append({ "type": res.rows[i].type, "value": res.rows[i].value });
        }
        else
        {
            /* Append Default Favorites, if needed */
            for(i = 0; i < defaultuseragents.length; i++)
                add(db, useragents, defaultuseragents[i].type, defaultuseragents[i].value);
        }
    });
}

function add(db, useragents, type, value)
{
    useragents.append({ "type": type, "value": value });

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO UserAgents (type, value) VALUES (?, ?);", [type, value]);
    });
}
