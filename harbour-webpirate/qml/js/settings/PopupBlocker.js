.pragma library

.import "../UrlHelper.js" as UrlHelper

var AllowRule = 0, BlockRule = 1, NoRule = 2;

function load(tx)
{
    tx.executeSql("CREATE TABLE IF NOT EXISTS PopupBlocker (domain TEXT PRIMARY KEY, popuprule INTEGER)");
}

function clearRules(db)
{
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM PopupBlocker");
    });
}

function getRule(db, url)
{
    var popuprule = NoRule;

    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT popuprule FROM PopupBlocker WHERE domain = ?", [UrlHelper.domainName(url)]);

        if(res.rows.length)
            popuprule = res.rows[0].popuprule;
    });

    return popuprule;
}

function setRule(db, url, popuprule)
{
    if(!url || !url.length)
        return;

    db.transaction(function(tx) {
        if(popuprule === NoRule)
            tx.executeSql("DELETE FROM PopupBlocker WHERE domain = ?", [UrlHelper.domainName(url)]);
        else
            tx.executeSql("INSERT OR REPLACE INTO PopupBlocker (domain, popuprule) VALUES (?, ?)", [UrlHelper.domainName(url), popuprule]);
    });
}

function fetchAll(db, popupmodel)
{
    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT * FROM PopupBlocker");

        if(res.rows.length)
            popupmodel.populate(res.rows);
        else
            popupmodel.clear();
    });
}
