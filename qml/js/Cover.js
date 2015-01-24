.pragma library

function createSchema(db)
{
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS CoverSettings(category INTEGER PRIMARY KEY, leftaction INTEGER, rightaction INTEGER)");
    });
}

function load(db, categoryid)
{
    var settings = new Object;

    db.transaction(function(tx) {
        var res = tx.executeSql("SELECT leftaction, rightaction FROM CoverSettings WHERE category=?", [categoryid]);

        if(!res.rows.length) /* Fallback to default settings */
        {
            settings.left = 0;
            settings.right = 1;
            return;
        }

        settings.left = res.rows[0].leftaction;
        settings.right = res.rows[0].rightaction;
    });

    return settings;
}

function save(db, categoryid, left, right)
{
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO CoverSettings (category, leftaction, rightaction) VALUES(?, ?, ?)", [categoryid, left, right]);
    });
}
