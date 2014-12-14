.pragma library

.import "GibberishAES.js" as AES

function createSchema(db)
{
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS Credentials (url TEXT, formid TEXT, loginattribute TEXT, loginid TEXT, login TEXT, passwordattribute TEXT, passwordid TEXT, password TEXT)");
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

function store(db, settings, url, formid, loginattribute, loginid, login, passwordattribute, passwordid, password)
{
    var key = generateKey(settings);

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO Credentials (url, formid, loginattribute, loginid, login, passwordattribute, passwordid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?) WHERE url=? AND formid=?;",
                      [url, formid, loginattribute, loginid, AES.enc(login, key), passwordattribute, passwordid, AES.enc(password, key), url, formid]);
    })
}
