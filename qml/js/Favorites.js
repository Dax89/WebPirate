.pragma library

var defaultfavorites = [ { "title": "Jolla", "url": "https://jolla.com/" },
                         { "title": "Jolla Together", "url": "https://together.jolla.com/questions/" },
                         { "title": "Jolla Users", "url": "http://www.jollausers.com/" },
                         { "title": "Maemo Talk", "url": "http://talk.maemo.org/" },
                         { "title": "Sailfish OS", "url": "https://www.sailfishos.org/"} ];

function load(db, favorites)
{
    var i = 0;

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Favorites (url TEXT PRIMARY KEY, title TEXT, icon TEXT)");
        var res = tx.executeSql("SELECT * FROM Favorites;");

        if(res.rows.length > 0)
        {
            for(i = 0; i < res.rows.length; i++)
                favorites.append({ "title": res.rows[i].title, "url": res.rows[i].url, "icon": res.rows[i].icon });
        }
        else
        {
            /* Append Default Favorites, if needed */
            for(i = 0; i < defaultfavorites.length; i++)
                add(db, favorites, defaultfavorites[i].title, defaultfavorites[i].url);
        }
    });
}

function add(db, favorites, title, url, icon)
{
    favorites.append({ "title": title, "url": url, "icon": icon ? icon : "" });

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO Favorites (url, title, icon) VALUES (?, ?, ?);", [url, title, icon ? icon : "" ]);
    });
}

function replace(db, favorites, index, title, url)
{
    db.transaction(function(tx) {
        tx.executeSql("UPDATE Favorites SET url=?, title=?, icon='' WHERE url=? AND title=?;", [url, title, favorites.get(index).url, favorites.get(index).title]);
    });

    var favorite = favorites.get(index);
    favorite.url = url;
    favorite.title = title;
    favorite.icon = "";
}

function remove(db, favorites, url)
{
    var idx = favorites.indexOf(url);

    if(idx === -1)
        return;

    favorites.remove(idx);

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Favorites WHERE url= ?;", [url]);
    });
}

function setIcon(db, favorites, url, icon)
{
    var idx = favorites.indexOf(url);

    if(idx === -1)
        return;

    db.transaction(function(tx) {
        tx.executeSql("UPDATE Favorites SET icon=? WHERE url=?;", [icon, url]);
    });

    var favorite = favorites.get(idx);
    favorite.icon = icon;
}
