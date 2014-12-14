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

function compile(db, settings, url, webview)
{
    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM Credentials WHERE url=?;", [url]);

        if(res.rows.length <= 0)
            return;

        var k = generateKey(settings);

        for(var i = 0; i < res.rows.length; i++)
        {
            var row = res.rows[i];

            if(row.loginattribute === "name")
                webview.experimental.evaluateJavaScript("document.getElementsByName('" + row.loginid + "')[0].value = '" + AES.dec(row.login, k) + "'");
            else if(row.loginattribute === "id")
                webview.experimental.evaluateJavaScript("document.getElementById('" + row.loginid + "').value = '" + AES.dec(row.login, k) + "'");

            if(row.passwordattribute === "name")
                webview.experimental.evaluateJavaScript("document.getElementsByName('" + row.passwordid + "')[0].value = '" + AES.dec(row.password, k) + "'");
            else if(row.passwordattribute === "id")
                webview.experimental.evaluateJavaScript("document.getElementById('" + row.passwordid + "').value = '" + AES.dec(row.password, k) + "'");
        }
    });
}
