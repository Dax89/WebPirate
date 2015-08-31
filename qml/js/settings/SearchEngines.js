.pragma library

var defaultsearchengines = [ { "name": "DuckDuckGo",
                               "query": "https://duckduckgo.com/?q=" },

                             { "name": "Google",
                               "query": "https://encrypted.google.com/search?q=" } ];

function load(tx, searchengines)
{
    var i = 0;
    tx.executeSql("CREATE TABLE IF NOT EXISTS SearchEngines (name TEXT PRIMARY KEY, query TEXT)");
    var res = tx.executeSql("SELECT * FROM SearchEngines;");

    if(res.rows.length > 0)
    {
        for(i = 0; i < res.rows.length; i++)
            searchengines.append({ "name": res.rows[i].name, "query": res.rows[i].query });
    }
    else
    {
        for(i = 0; i < defaultsearchengines.length; i++)
            transactionAdd(tx, searchengines, defaultsearchengines[i].name, defaultsearchengines[i].query);
    }
}

function transactionAdd(tx, searchengines, name, query)
{
    searchengines.append({ "name": name, "query": query })
    tx.executeSql("INSERT OR REPLACE INTO SearchEngines (name, query) VALUES (?, ?);", [name, query]);
}

function add(db, searchengines, name, query)
{
    db.transaction(function(tx) {
        transactionAdd(tx, searchengines, name, query);
    });
}

function replace(db, searchengines, index, name, query)
{
    db.transaction(function(tx) {
        tx.executeSql("UPDATE SearchEngines SET name=?, query=? WHERE name=?;", [name, query, searchengines.get(index).name]);
    });

    var searchengine = searchengines.get(index);
    searchengine.name = name;
    searchengine.query = query;
}

function remove(db, searchengines, name)
{
    var idx = searchengines.indexOf(name);

    if(idx === -1)
        return;

    searchengines.remove(idx);

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM SearchEngines WHERE name=?;", [name]);
    });
}
