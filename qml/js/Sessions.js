.pragma library

.import QtQuick.LocalStorage 2.0 as Storage

function instance()
{
    return Storage.LocalStorage.openDatabaseSync("Session", "1.0", "Saved Sessions", 2000000);  /* DB Size: 2MB */
}

function createSchema()
{
    instance().transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Sessions(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, replacecurrent INTEGER)");
        tx.executeSql("CREATE TABLE IF NOT EXISTS SessionData(id INTEGER, title, TEXT, url TEXT, current INTEGER)");
        tx.executeSql("CREATE TABLE IF NOT EXISTS SessionConfig(key TEXT, value INTEGER)");
    });
}

function setStartupId(sessionid)
{
    instance().transaction(function(tx) {
        transactionSetStartupId(tx, sessionid);
    });
}

function transactionSetStartupId(tx, sessionid)
{
    tx.executeSql("INSERT OR REPLACE INTO SessionConfig (key, value) VALUES('autoload', ?)", [sessionid]);
}

function startupId()
{
    var sessionid = -1;

    instance().transaction(function(tx) {
        sessionid = transactionStartupId(tx);
    });

    return sessionid;
}

function transactionStartupId(tx)
{
    var res = tx.executeSql("SELECT value FROM SessionConfig WHERE key='autoload'");

    if(res.rows.length > 0)
        return res.rows[0].value;

    return -1;
}

function transactionGet(tx, sessionid)
{
    var res = tx.executeSql("SELECT * FROM Sessions WHERE id=?", [sessionid]);

    if(!res)
        return null;

    var session = new Object;
    session.id = res.rows[0].id;
    session.name = res.rows[0].name;
    session.replacecurrent = res.rows[0].replacecurrent;
    session.autoload = transactionStartupId(tx) === session.id;

    res = tx.executeSql("SELECT title, url, current FROM SessionData WHERE id=?", [sessionid]);

    if(!res)
        return null;

    session.tabs = res.rows;
    return session;
}

function getAll(sessionmodel)
{
    sessionmodel.clear();

    instance().transaction(function(tx) {
        var res = tx.executeSql("SELECT id, name FROM Sessions");

        if(!res)
            return;

        for(var i = 0; i < res.rows.length; i++)
        {
            var count = tx.executeSql("SELECT COUNT(*) FROM SessionData WHERE id=?", [res.rows[i].id]);
            sessionmodel.append({ "sessionid": res.rows[i].id, "name": res.rows[i].name, "count": count.rows[0]["COUNT(*)"] });
        }
    });
}

function get(sessionid)
{
    var session = null;

    instance().transaction(function(tx) {
        session = transactionGet(tx, sessionid);
    });

    return session;
}

function save(name, pages, currentindex, autoload, replacecurrent)
{
    instance().transaction(function(tx) {
        transactionSave(tx, name, pages, currentindex, autoload, replacecurrent);
    });
}

function transactionSave(tx, name, pages, currentindex, autoload, replacecurrent)
{
    var res = tx.executeSql("INSERT INTO Sessions (name, replacecurrent) VALUES (?, ?)", [name, replacecurrent ? 1 : 0]);
    var sessionid = parseInt(res.insertId);

    for(var i = 0; i < pages.count; i++)
    {
        var tab = pages.get(i).tab;
        tx.executeSql("INSERT INTO SessionData (id, title, url, current) VALUES(?, ?, ?, ?)", [sessionid, tab.getTitle(), tab.getUrl(), (i === currentindex ? 1 : 0)]);
    }

    if(autoload)
        tx.executeSql("INSERT OR REPLACE INTO SessionConfig (key, value) VALUES ('autoload', ?)", [sessionid]);
}

function load(sessionid, tabview)
{
    instance().transaction(function(tx) {
        var session = transactionGet(tx, sessionid);

        if(!session)
            return;

        if(session.replacecurrent)
            tabview.removeAllTabs();

        var selectedtab = -1;

        for(var i = 0; i < session.tabs.length; i++)
        {
            tabview.addTab(session.tabs[i].url);

            if(session.tabs[i].current)
                selectedtab = i;
        }

        if(selectedtab !== -1)
            tabview.currentIndex = selectedtab;
    });
}

function remove(sessionid)
{
    instance().transaction(function(tx) {
        transactionRemove(tx, sessionid);
    });
}

function transactionRemove(tx, sessionid)
{
    tx.executeSql("DELETE FROM SessionData WHERE id=?", [sessionid]);
    tx.executeSql("DELETE FROM Sessions WHERE id=?", [sessionid]);

    if(transactionStartupId(tx) === sessionid)
        tx.executeSql("DELETE FROM SessionConfig WHERE key='autoload'");
}

function update(sessionid, name, autoload, replacecurrent)
{
    instance().transaction(function(tx) {
        tx.executeSql("UPDATE Sessions SET name=?, replacecurrent=? WHERE id=?", [name, replacecurrent, sessionid]);

        if(autoload)
            transactionSetStartupId(tx, sessionid);
        else if(!autoload && (transactionStartupId(tx) === sessionid))
            tx.executeSql("DELETE FROM SessionConfig WHERE key='autoload'");
    });
}
