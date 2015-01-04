import QtQuick 2.0
import "../js/Database.js" as Database
import "../js/QuickGrid.js" as QuickGrid

ListModel
{
    readonly property int maxitems: 9

    id: quickgridmodel

    function replace(index, title, url)
    {
        var item = quickgridmodel.get(index);
        item.title = title;
        item.url = url;

        QuickGrid.set(Database.instance(), index, title, url);
    }
}
