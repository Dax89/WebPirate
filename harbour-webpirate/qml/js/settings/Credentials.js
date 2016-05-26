.pragma library

.import harbour.webpirate.Security 1.0 as Security
.import harbour.webpirate.DBus 1.0 as DBus
.import harbour.webpirate.Network 1.0 as Network
.import "../UrlHelper.js" as UrlHelper

function createSchema(tx)
{
    tx.executeSql("CREATE TABLE IF NOT EXISTS Credentials (url TEXT, loginattribute TEXT, loginid TEXT, login TEXT, passwordattribute TEXT, passwordid TEXT, password TEXT)");
}

function generateKey()
{
    var ofono = DBus.Ofono;

    if(ofono.available && (ofono.imeiCount > 0))
        return ofono.imei(0);

    /* No IMEI: Fallback to MAC address */
    var interfaces = Network.NetworkInterfaces;

    if(interfaces.interfaceCount > 0)
        return interfaces.interfaceMAC(0);

    /* No MAC: Fallback to Machine ID */
    return DBus.MachineID.value;
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

function store(db, url, logindata)
{
    var key = generateKey();

    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM Credentials WHERE url=? AND loginid=? AND passwordid=?;", [UrlHelper.urlPath(url), logindata.loginId, logindata.passwordId]);
        tx.executeSql("INSERT INTO Credentials (url, loginattribute, loginid, login, passwordattribute, passwordid, password) VALUES (?, ?, ?, ?, ?, ?, ?);",
                      [UrlHelper.urlPath(url), logindata.loginAttribute, logindata.loginId, Security.AES256.encode(logindata.login, key), logindata.passwordAttribute, logindata.passwordId,
                       Security.AES256.encode(logindata.password, key)]);
    })
}

function needsDialog(db, url, logindata)
{
    var r = true;
    var key = generateKey();

    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM Credentials WHERE url=? AND loginid=? AND passwordid=?;", [UrlHelper.urlPath(url), logindata.loginId, logindata.passwordId]);

        if(res.rows.length > 0)
            r = (logindata.login !== Security.AES256.decode(res.rows[0].login, key)) || (logindata.password !== Security.AES256.decode(res.rows[0].password, key));
    });

    return r;
}

function compile(db, url, webview)
{
    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM Credentials WHERE url=?;", [UrlHelper.urlPath(url)]);

        if(res.rows.length <= 0)
            return;

        var k = generateKey();

        for(var i = 0; i < res.rows.length; i++)
        {
            var row = res.rows[i];

            if(row.loginAttribute === "name")
                webview.experimental.evaluateJavaScript("document.getElementsByName('" + row.loginId + "')[0].value = '" + Security.AES256.decode(row.login, k) + "'");
            else if(row.loginAttribute === "id")
                webview.experimental.evaluateJavaScript("document.getElementById('" + row.loginId + "').value = '" + Security.AES256.decode(row.login, k) + "'");

            if(row.passwordAttribute === "name")
                webview.experimental.evaluateJavaScript("document.getElementsByName('" + row.passwordId + "')[0].value = '" + Security.AES256.decode(row.password, k) + "'");
            else if(row.passwordAttribute === "id")
                webview.experimental.evaluateJavaScript("document.getElementById('" + row.passwordId + "').value = '" + Security.AES256.decode(row.password, k) + "'");
        }
    });
}
