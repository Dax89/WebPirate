.pragma library

.import QtQuick.LocalStorage 2.0 as Storage

var defaultfavorites = [ { "title": "Jolla", "url": "https://jolla.com/" },
                         { "title": "Jolla Together", "url": "https://together.jolla.com/questions/" },
                         { "title": "Jolla Users", "url": "http://www.jollausers.com/" },
                         { "title": "Maemo Talk", "url": "https://talk.maemo.org/" },
                         { "title": "Sailfish OS", "url": "https://www.sailfishos.org/"} ];

function instance()
{
    return Storage.LocalStorage.openDatabaseSync("Favorites", "1.0", "WebPirate Favorites", 5000000);  /* DB Size: 5MB */
}

function load(maindb)
{
    instance().transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Favorites (favoriteid INTEGER PRIMARY KEY AUTOINCREMENT, parentid INTEGER, url TEXT, title TEXT, isfolder INTEGER)");
        tx.executeSql("CREATE TABLE IF NOT EXISTS FavoritesTree (parentid INTEGER, childid INTEGER, PRIMARY KEY(parentid, childid))");
        migrate(maindb);

        var res = tx.executeSql("SELECT COUNT(*) FROM Favorites");

        if(!res.rows[0]["COUNT(*)"])
        {
            /* Append Default Favorites, if needed */
            for(var i = 0; i < defaultfavorites.length; i++)
                transactionAddUrl(tx, defaultfavorites[i].title, defaultfavorites[i].url, 0);
        }
    });
}

function deleteAll()
{
    instance().transaction(function(tx) {
        tx.executeSql("DELETE FROM Favorites");
        tx.executeSql("DELETE FROM FavoritesTree");
    });
}

function contains(url)
{
    var exists = false;

    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT COUNT(*) FROM Favorites WHERE url = ? AND isfolder = 0 LIMIT 1", [url]);
        exists = res.rows[0]["COUNT(*)"] > 0;
    });

    return exists;
}

function clear()
{
    instance().transaction(function(tx) {
        tx.executeSql("DROP TABLE IF EXISTS Favorites");
        tx.executeSql("DROP TABLE IF EXISTS FavoritesTree");
    });
}

function readChildren(parentid, model)
{
    model.busy = true;
    model.clear();

    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM Favorites WHERE parentid = ?", [parentid]);

        for(var i = 0; i < res.rows.length; i++)
            model.append(res.rows[i]);

        model.busy = false;
    });
}

function migrate(maindb) // Migrate Old Favorites Table to the new one
{
    maindb.transaction(function(tx) {
        var res = tx.executeSql("SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='Favorites'");

        if(!res.rows[0]["COUNT(*)"])
            return;

        res = tx.executeSql("SELECT url, title FROM Favorites");

        for(var i = 0; i < res.rows.length; i++)
            addUrl(res.rows[i].title, res.rows[i].url, 0);

        tx.executeSql("DROP TABLE Favorites");
    });
}

function get(favoriteid)
{
    var favorite = null;

    instance().transaction(function(tx) {
        favorite = transactionGet(tx, favoriteid);
    });

    return favorite;
}

function transactionAddFolder(tx, title, parentid)
{
    var result = new Object;
    var res = tx.executeSql("SELECT favoriteid FROM Favorites WHERE parentid=? AND url IS NULL AND title=? AND isfolder=1 LIMIT 1", [parentid, title]);

    if(res.rows.length > 0) /* Avoid Duplicates */
    {
        result.added = false;
        result.id = parseInt(res.rows[0].favoriteid);
    }
    else
    {
        res = tx.executeSql("INSERT INTO Favorites (parentid, url, title, isfolder) VALUES (?, NULL, ?, 1)", [parentid, title]);

        result.added = true;
        result.id = parseInt(res.insertId);

        tx.executeSql("INSERT INTO FavoritesTree (parentid, childid) VALUES (?, ?)", [parentid, result.id]);
    }

    return result;
}

function transactionAddUrl(tx, title, url, parentid)
{
    var result = new Object;
    var res = tx.executeSql("SELECT favoriteid FROM Favorites WHERE parentid=? AND url=? AND title=? AND isfolder=0 LIMIT 1", [parentid, url, title]);

    if(res.rows.length > 0) /* Avoid Duplicates */
    {
        result.added = false;
        result.id = parseInt(res.rows[0].favoriteid);
    }
    else
    {
        res = tx.executeSql("INSERT INTO Favorites (parentid, url, title, isfolder) VALUES (?, ?, ?, 0)", [parentid, url, title]);

        result.added = true;
        result.id = parseInt(res.insertId);

        tx.executeSql("INSERT INTO FavoritesTree (parentid, childid) VALUES (?, ?)", [parentid, result.id]);
    }

    return result;
}

function transactionGet(tx, favoriteid)
{
    var favorite = null;
    var res = tx.executeSql("SELECT * FROM Favorites WHERE favoriteid=?", [favoriteid]);

    if(res.rows.length)
        favorite = res.rows[0];

    return favorite;
}

function transactionRemove(tx, favoriteid)
{
    var favorite = transactionGet(tx, favoriteid);
    var res = tx.executeSql("SELECT * FROM FavoritesTree WHERE parentid = ?", [favoriteid]);

    for(var i = 0; i < res.rows.length; i++)
        transactionRemove(tx, res.rows[i].childid);

    tx.executeSql("DELETE FROM Favorites WHERE favoriteid = ?", [favoriteid]);
    tx.executeSql("DELETE FROM FavoritesTree WHERE parentid = ?", [favoriteid]);
    tx.executeSql("DELETE FROM FavoritesTree WHERE parentid = ? AND childid = ?", [favorite.parentid, favoriteid]);
}

function addFolder(title, parentid)
{
    var result = null;

    instance().transaction(function(tx) {
        result = transactionAddFolder(tx, title, parentid);
    });

    return result.id;
}

function addUrl(title, url, parentid)
{
    var result = null;

    instance().transaction(function(tx) {
        result = transactionAddUrl(tx, title, url, parentid ? parentid : 0);
    });

    return result.id;
}

function replaceFolder(id, title)
{
    instance().transaction(function(tx) {        
        tx.executeSql("UPDATE Favorites SET title = ? WHERE favoriteid = ?", [title, id]);
    });
}

function replaceUrl(id, title, url)
{
    instance().transaction(function(tx) {
        tx.executeSql("UPDATE Favorites SET url = ?, title = ? WHERE favoriteid = ?", [url, title, id]);
    });
}

function removeFromUrl(url)
{
    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT favoriteid FROM Favorites WHERE url = ?", [url]);

        if(res.rows.length > 0)
            transactionRemove(tx, res.rows[0].favoriteid);
    });
}

function remove(id)
{
    instance().transaction(function(tx) {
        transactionRemove(tx, id);
    });
}

function doImport(rootfolder, parentid, favoritesmodel)
{
    instance().transaction(function(tx) {
        for(var i = 0; i < rootfolder.favorites.length; i++) {
            var f = rootfolder.favorites[i];

            if(f.isFolder) {
                var folderresult = importFolder(tx, f, parentid);

                if(folderresult.added)
                    favoritesmodel.addFolderInView(f.title, folderresult.id, parentid);
            }
            else {
                var urlresult = transactionAddUrl(tx, f.title, f.url, parentid);

                if(urlresult.added)
                    favoritesmodel.addUrlInView(f.title, f.url, urlresult.id, parentid);
            }
        }
    });
}

function importFolder(tx, folder, parentid)
{
    var result = transactionAddFolder(tx, folder.title, parentid);

    for(var i = 0; i < folder.favorites.length; i++)
    {
        var f = folder.favorites[i];

        if(f.isFolder)
            importFolder(tx, f, result.id);
        else
            transactionAddUrl(tx, f.title, f.url, result.id);
    }

    return result;
}

function doExport(favoritesmanager, folderid, foldername)
{
    instance().transaction(function(tx) {
        favoritesmanager.createRoot();
        exportFolder(tx, favoritesmanager.root, folderid);
    });

    favoritesmanager.exportFile(foldername);
}

function exportFolder(tx, foldernode, folderid)
{
    var res = tx.executeSql("SELECT * FROM Favorites WHERE parentid = ? ", [folderid]);

    for(var i = 0; i < res.rows.length; i++)
    {
        var row = res.rows[i];

        if(row.isfolder)
        {
            var folder = foldernode.addFolder(row.title);
            exportFolder(tx, folder, row.favoriteid);
        }
        else
            foldernode.addFavorite(row.title, row.url);
    }
}
