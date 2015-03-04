.pragma library

.import WebPirate.Security 1.0 as Security
.import "../UrlHelper.js" as UrlHelper

function createSchema(tx)
{
    tx.executeSql("CREATE TABLE IF NOT EXISTS Credentials (url TEXT, loginattribute TEXT, loginid TEXT, login TEXT, passwordattribute TEXT, passwordid TEXT, password TEXT)");
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
        createSchema(tx);
    });
}

function remove(db, url, loginid, passwordid)
{
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Credentials WHERE url=? AND loginid=? AND passwordid=?;", [UrlHelper.urlPath(url), loginid, passwordid]);
    });
}

function store(db, settings, url, logindata)
{
    var key = generateKey(settings);

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Credentials WHERE url=? AND loginid=? AND passwordid=?;", [UrlHelper.urlPath(url), logindata.loginid, logindata.passwordid]);
        tx.executeSql("INSERT INTO Credentials (url, loginattribute, loginid, login, passwordattribute, passwordid, password) VALUES (?, ?, ?, ?, ?, ?, ?);",
                      [UrlHelper.urlPath(url), logindata.loginattribute, logindata.loginid, Security.AES256.encode(logindata.login, key), logindata.passwordattribute, logindata.passwordid,
                       Security.AES256.encode(logindata.password, key)]);
    })
}

function needsDialog(db, settings, url, logindata)
{
    var r = true;
    var key = generateKey(settings);

    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM Credentials WHERE url=? AND loginid=? AND passwordid=?;", [UrlHelper.urlPath(url), logindata.loginid, logindata.passwordid]);

        if(res.rows.length > 0)
            r = (logindata.login !== Security.AES256.decode(res.rows[0].login, key)) || (logindata.password !== Security.AES256.decode(res.rows[0].password, key));
    });

    return r;
}

function compile(db, settings, url, webview)
{
    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM Credentials WHERE url=?;", [UrlHelper.urlPath(url)]);

        if(res.rows.length <= 0)
            return;

        var k = generateKey(settings);

        for(var i = 0; i < res.rows.length; i++)
        {
            var row = res.rows[i];

            if(row.loginattribute === "name")
                webview.experimental.evaluateJavaScript("document.getElementsByName('" + row.loginid + "')[0].value = '" + Security.AES256.decode(row.login, k) + "'");
            else if(row.loginattribute === "id")
                webview.experimental.evaluateJavaScript("document.getElementById('" + row.loginid + "').value = '" + Security.AES256.decode(row.login, k) + "'");

            if(row.passwordattribute === "name")
                webview.experimental.evaluateJavaScript("document.getElementsByName('" + row.passwordid + "')[0].value = '" + Security.AES256.decode(row.password, k) + "'");
            else if(row.passwordattribute === "id")
                webview.experimental.evaluateJavaScript("document.getElementById('" + row.passwordid + "').value = '" + Security.AES256.decode(row.password, k) + "'");
        }
    });
}
