.pragma library

var defaultfavorites = [ { "title": "Jolla", "url": "https://www.jolla.com" },
                         { "title": "Jolla Together", "url": "https://together.jolla.com" },
                         { "title": "Jolla Users", "url": "http://www.jollausers.com" },
                         { "title": "Maemo Talk", "url": "http://talk.maemo.org" },
                         { "title": "Sailfish OS", "url": "http://www.sailfishos.org"} ];

function load(db)
{
    var favorites = new Array;

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Favorites (title TEXT PRIMARY KEY, url TEXT)");
        var res = tx.executeSql("SELECT * FROM Favorites;");

        if(res.rows.length > 0)
        {
            for(var i = 0; i < res.rows.length; i++)
                favorites.push({ "title": res.rows[i].title, "url": res.rows[i].url });
        }
        else
            favorites = defaultfavorites;
    });

    return favorites
}
