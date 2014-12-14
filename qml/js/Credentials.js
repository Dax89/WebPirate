.pragma library

.import "GibberishAES.js" as AES

function createSchema(db)
{
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Credentials (url TEXT, loginattribute TEXT, loginid TEXT, login TEXT, passwordattribute TEXT, passwordid TEXT, password TEXT)");
    });
}

function generateKey(settings)
{
    if(settings.deviceinfo.imeiCount() > 0)
        return settings.deviceinfo.imei(0);

    return settings.deviceinfo.uniqueDeviceID();
}

function clear(db)
{
    db.transaction(function(tx) {
        tx.executeSql("DROP TABLE IF EXISTS Credentials");
    });

    createSchema(db);
}

function remove(db, url, loginid, passwordid)
{
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Credentials WHERE url=? AND loginid=? AND passswordid=?;", [url, loginid, passwordid]);
    });
}

function store(db, settings, url, loginattribute, loginid, login, passwordattribute, passwordid, password)
{
    var key = generateKey(settings);

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Credentials WHERE url=? AND loginid=? AND passwordid=?;", [url, loginid, passwordid]);
        tx.executeSql("INSERT INTO Credentials (url, loginattribute, loginid, login, passwordattribute, passwordid, password) VALUES (?, ?, ?, ?, ?, ?, ?);",
                      [url, loginattribute, loginid, AES.enc(login, key), passwordattribute, passwordid, AES.enc(password, key)]);
    })
}
