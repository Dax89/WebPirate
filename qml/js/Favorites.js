.pragma library

var defaultfavorites = [ { "title": "Jolla", "url": "https://jolla.com/" },
                         { "title": "Jolla Together", "url": "https://together.jolla.com/" },
                         { "title": "Jolla Users", "url": "http://www.jollausers.com/" },
                         { "title": "Maemo Talk", "url": "http://talk.maemo.org/" },
                         { "title": "Sailfish OS", "url": "http://www.sailfishos.org/"} ];

function load(db, favorites)
{
    var i = 0;

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Favorites (url TEXT PRIMARY KEY, title TEXT)");
        var res = tx.executeSql("SELECT * FROM Favorites;");

        if(res.rows.length > 0)
        {
            for(i = 0; i < res.rows.length; i++)
                favorites.append({ "title": res.rows[i].title, "url": res.rows[i].url });
        }
        else
        {
            /* Append Default Favorites, if needed */
            for(i = 0; i < defaultfavorites.length; i++)
                add(db, favorites, defaultfavorites[i].title, defaultfavorites[i].url);
        }
    });
}

function add(db, favorites, title, url)
{
    favorites.append({ "title": title, "url": url });

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO Favorites (url, title) VALUES (?, ?);", [url, title]);
    });
}

function replace(db, favorites, index, title, url)
{
    db.transaction(function(tx) {
        tx.executeSql("UPDATE Favorites SET url=?, title=? WHERE url=? AND title=?;", [url, title, favorites.get(index).url, favorites.get(index).title]);
    });

    var favorite = favorites.get(index)
    favorite.url = url
    favorite.title = title
}

function remove(db, favorites, url)
{
    for(var i = 0; i < favorites.count; i++)
    {
        if(favorites.get(i).url === url)
        {
            favorites.remove(i);
            break;
        }
    }

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Favorites WHERE url= ?;", [url]);
    });
}
