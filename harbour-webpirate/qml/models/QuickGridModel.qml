import QtQuick 2.1
import "../js/settings/Database.js" as Database
import "../js/settings/QuickGrid.js" as QuickGrid

ListModel
{
    property int availableId: 0

    id: quickgridmodel

    function replace(index, title, url)
    {
        var item = quickgridmodel.get(index);
        item.title = title;
        item.url = url;
    }

    function addUrl(title, url)
    {
        quickgridmodel.append({ "quickId": quickgridmodel.availableId, "title": title, "url": url });
        quickgridmodel.availableId++;
    }

    Component.onDestruction: QuickGrid.save(Database.instance(), quickgridmodel)
}
