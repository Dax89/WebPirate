.pragma library

.import QtQuick.LocalStorage 2.0 as Storage

function instance()
{
    return openDatabase("1.1")
}

function checkDBUpgrade()
{
    var db = openDatabase("");

    if(db.version === "1.0")
    {
        db.changeVersion("1.0", "1.1",
                         function(tx) {
                             /* Migrate Old SessionData Table */
                             var i, row = null, res = tx.executeSql("SELECT * FROM SessionData");
                             tx.executeSql("CREATE TABLE IF NOT EXISTS SessionTabs(id INTEGER, title TEXT, url TEXT, current INTEGER)");

                             for(i = 0; i < res.rows.length; i++) {
                                 row = res.rows[i];
                                 tx.executeSql("INSERT INTO SessionTabs (id, title, url, current) VALUES(?, ?, ?, ?)",
                                               [row.id, row.title, row.url, row.current]);
                             }

                             tx.executeSql("DROP TABLE IF EXISTS SessionData");

                             /* Migrate Old SessionConfig Table */
                             res = tx.executeSql("SELECT * FROM SessionConfig");
                             tx.executeSql("CREATE TABLE IF NOT EXISTS SessionFlags(key TEXT PRIMARY KEY, value INTEGER)");

                             for(i = 0; i < res.rows.length; i++) {
                                 row = res.rows[i];
                                 tx.executeSql("INSERT OR REPLACE INTO SessionFlags (key, value) VALUES(?, ?)", [row.key, row.value]);
                             }

                             tx.executeSql("DROP TABLE IF EXISTS SessionConfig");
                         });
    }
}

function openDatabase(version)
{
    return Storage.LocalStorage.openDatabaseSync("Session", version, "Saved Sessions", 2000000);  /* DB Size: 2MB */
}

function createSchema()
{
    checkDBUpgrade();
    var db = instance();

    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Sessions(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, replacecurrent INTEGER)");
        tx.executeSql("CREATE TABLE IF NOT EXISTS SessionTabs(id INTEGER, title TEXT, url TEXT, current INTEGER)");
        tx.executeSql("CREATE TABLE IF NOT EXISTS SessionFlags(key TEXT PRIMARY KEY, value INTEGER)");
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
    tx.executeSql("INSERT OR REPLACE INTO SessionFlags (key, value) VALUES('autoload', ?)", [sessionid]);
}

function startupId()
{
    var sessionid = -1;

    instance().transaction(function(tx) {
        sessionid = transactionStartupId(tx);
    });

    return sessionid;
}

function selfDestructId()
{
    var sessionid = -1;

    instance().transaction(function(tx) {
        sessionid = transactionSelfDestructId(tx);
    });

    return sessionid;
}

function transactionSelfDestructId(tx)
{
    var res = tx.executeSql("SELECT value FROM SessionFlags WHERE key='selfdestruct'");

    if(res.rows.length > 0)
        return res.rows[0].value;

    return -1;
}

function transactionStartupId(tx)
{
    var res = tx.executeSql("SELECT value FROM SessionFlags WHERE key='autoload'");

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

    res = tx.executeSql("SELECT title, url, current FROM SessionTabs WHERE id=?", [sessionid]);

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
            var count = tx.executeSql("SELECT COUNT(*) FROM SessionTabs WHERE id=?", [res.rows[i].id]);
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

function save(name, tabs, currentindex, autoload, replacecurrent, selfdestruct)
{
    instance().transaction(function(tx) {
        transactionSave(tx, name, tabs, currentindex, autoload, replacecurrent, selfdestruct);
    });
}

function transactionSave(tx, name, tabs, currentindex, autoload, replacecurrent, selfdestruct)
{
    var res = tx.executeSql("INSERT INTO Sessions (name, replacecurrent) VALUES (?, ?)", [name, replacecurrent ? 1 : 0]);
    var sessionid = parseInt(res.insertId);

    for(var i = 0; i < tabs.count; i++)
    {
        var tab = tabs.get(i).tab;
        tx.executeSql("INSERT INTO SessionTabs (id, title, url, current) VALUES(?, ?, ?, ?)", [sessionid, tab.getTitle(), tab.getUrl(), (i === currentindex ? 1 : 0)]);
    }

    if(autoload)
        tx.executeSql("INSERT OR REPLACE INTO SessionFlags (key, value) VALUES ('autoload', ?)", [sessionid]);

    if(selfdestruct)
        tx.executeSql("INSERT OR REPLACE INTO SessionFlags (key, value) VALUES ('selfdestruct', ?)", [sessionid]);
}

function load(sessionid, tabview)
{
    instance().transaction(function(tx) {
        var session = transactionGet(tx, sessionid);

        if(!session)
            return;

        if(session.replacecurrent)
            tabview.removeAllTabs();

        for(var i = 0; i < session.tabs.length; i++)
            tabview.addTab(session.tabs[i].url, session.tabs[i].current);

        if(transactionSelfDestructId(tx) === session.id)
            transactionRemove(tx, sessionid);
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
    tx.executeSql("DELETE FROM SessionTabs WHERE id=?", [sessionid]);
    tx.executeSql("DELETE FROM Sessions WHERE id=?", [sessionid]);

    if(transactionStartupId(tx) === sessionid)
        tx.executeSql("DELETE FROM SessionFlags WHERE key='autoload'");

    if(transactionSelfDestructId(tx) === sessionid)
        tx.executeSql("DELETE FROM SessionFlags WHERE key='selfdestruct'");
}

function update(sessionid, name, autoload, replacecurrent)
{
    instance().transaction(function(tx) {
        tx.executeSql("UPDATE Sessions SET name=?, replacecurrent=? WHERE id=?", [name, replacecurrent, sessionid]);

        if(autoload)
            transactionSetStartupId(tx, sessionid);
        else if(!autoload && (transactionStartupId(tx) === sessionid))
            tx.executeSql("DELETE FROM SessionFlags WHERE key='autoload'");
    });
}
