import QtQuick 2.0
import "../js/UrlHelper.js" as UrlHelper
import "../js/Favorites.js" as Favorites

ListModel
{
    property int currentId

    id: favorites

    function indexOf(favoriteid)
    {
        for(var i = 0; i < favorites.count; i++)
        {
            if(favoriteid === favorites.get(i).favoriteid)
                return i;
        }

        return -1;
    }

    function currentFolder()
    {
        var favorite = Favorites.get(currentId);
        return favorite.title;
    }

    function addFolder(title, parentid)
    {
        var favoriteid = Favorites.addFolder(title, parentid);

        if(currentId === parentid)
            favorites.append({ "parentid": parentid, "favoriteid": favoriteid, "url": "", "title": title, "isfolder": 1 });
    }

    function addUrl(title, url, parentid)
    {
        var favoriteid = Favorites.addUrl(title, url, parentid);

        if(currentId === parentid)
            favorites.append({ "parentid": parentid, "favoriteid": favoriteid, "url": url, "title": title, "isfolder": 0 });
    }

    function replace(favoriteid, title, url)
    {
        if(currentId === parentid)
        {
            var idx = indexOf(favoriteid);

            if(idx !== -1)
            {
                var favorite = favorites.get(idx);
                favorite.title = title;
                favorite.url = url;
            }
        }

        Favorites.replace(favoriteid, title, url);
    }

    function jumpTo(favoriteid)
    {
        currentId = favoriteid;
        Favorites.readChildren(favoriteid, favorites);
    }

    function jumpBack()
    {
        if(currentId === 0)
            return;

        var favorite = Favorites.get(currentId);
        jumpTo(favorite.parentid);
    }

    function jumpToRoot()
    {
        jumpTo(0);
    }

    Component.onCompleted: jumpToRoot()
}
