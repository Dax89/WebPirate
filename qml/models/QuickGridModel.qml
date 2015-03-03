import QtQuick 2.1
import "../js/settings/Database.js" as Database
import "../js/settings/QuickGrid.js" as QuickGrid

ListModel
{
    property bool specialAdded: false

    id: quickgridmodel

    function replace(index, title, url)
    {
        var item = quickgridmodel.get(index);
        item.title = title;
        item.url = url;
    }

    function addUrl(title, url)
    {
        if(specialAdded)
            quickgridmodel.insert((!quickgridmodel.count ? 0 : (quickgridmodel.count - 1)), { "special": false, "title": title, "url": url });
        else
            quickgridmodel.append({ "special": false, "title": title, "url": url });
    }

    function addEmpty()
    {
        if(specialAdded)
            quickgridmodel.insert((!quickgridmodel.count ? 0 : (quickgridmodel.count - 1)), { "special": false, "title": "", "url": "" });
        else
            quickgridmodel.insert({ "special": false, "title": "", "url": "" });
    }

    function addSpecial()
    {
        quickgridmodel.append({ "special": true, "title": "", "url": "" });
        specialAdded = true;
    }

    Component.onDestruction: QuickGrid.save(Database.instance(), quickgridmodel)
}
