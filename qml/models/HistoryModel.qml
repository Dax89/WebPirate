import QtQuick 2.1

ListModel
{
    id: historymodel

    function populate(sqlrows)
    {
        historymodel.clear();

        for(var i = 0; i < sqlrows.length; i++)
        {
            var row = sqlrows[i];
            var date = new Date(row.lastvisit);

            historyModel.append({ "date": date.toDateString(), "time": date.toTimeString(), "title": row.title, "url": row.url })
        }
    }
}
