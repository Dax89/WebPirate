.pragma library

var defaultsearchengines = [ { "name": "DuckDuckGo",
                               "query": "http://duckduckgo.com/?q=" },

                             { "name": "Google",
                               "query": "https://www.google.it/search?q=" } ];

function load(db)
{
    var searchengines = new Array;

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS SearchEngines (name TEXT PRIMARY KEY, query TEXT)");
        var res = tx.executeSql("SELECT * FROM SearchEngines;");

        if(res.rows.length > 0)
        {
            for(var i = 0; i < res.rows.length; i++)
                searchengines.push({ "name": res.rows[i].name, "query": res.rows[i].query });
        }
        else
            searchengines = defaultsearchengines;
    });

    return searchengines;
}

function save(db, searchengines)
{
    db.transaction(function(tx) {
        for(var i = 0; i < searchengines.length; i++)
            tx.executeSql("INSERT OR REPLACE INTO SearchEngines (name, query) VALUES (?, ?);", [searchengines[i].name, searchengines[i].query]);
    });
}
