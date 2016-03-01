import QtQuick 2.1

ListModel
{
    property bool busy: true

    id: historymodel

    function populate(sqlrows)
    {
        historymodel.busy = true;
        historymodel.clear();

        for(var i = 0; i < sqlrows.length; i++)
        {
            var row = sqlrows[i];
            var date = new Date(row.lastvisit);

            historymodel.append({ "date": date.toDateString(), "time": date.toTimeString(), "title": row.title, "url": row.url })
        }

        historymodel.busy = false;
    }
}
