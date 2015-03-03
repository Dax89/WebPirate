import QtQuick 2.1
import "../js/settings/Database.js" as Database
import "../js/settings/QuickGrid.js" as QuickGrid

ListModel
{
    id: quickgridmodel

    function replace(index, title, url)
    {
        var item = quickgridmodel.get(index);
        item.title = title;
        item.url = url;
    }

    function addEmpty()
    {
        quickgridmodel.insert(quickgridmodel.count - 1, { "special": false, "title": "", "url": "" });
    }

    Component.onDestruction: QuickGrid.save(Database.instance(), quickgridmodel)
}
