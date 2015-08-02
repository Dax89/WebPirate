import QtQuick 2.1
import "../js/UrlHelper.js" as UrlHelper
import "../js/settings/Favorites.js" as Favorites

ListModel
{
    property int currentId
    property bool busy: true

    id: favoritesmodel

    function indexOf(favoriteid)
    {
        for(var i = 0; i < favoritesmodel.count; i++)
        {
            if(favoriteid === favoritesmodel.get(i).favoriteid)
                return i;
        }

        return -1;
    }

    function addFolderInView(title, favoriteid, parentid)
    {
        favoritesmodel.append({ "parentid": parentid, "favoriteid": favoriteid, "url": "", "title": title, "isfolder": 1 });
    }

    function addUrlInView(title, url, favoriteid, parentid)
    {
        favoritesmodel.append({ "parentid": parentid, "favoriteid": favoriteid, "url": url, "title": title, "isfolder": 0 });
    }

    function currentFolder()
    {
        var favorite = Favorites.get(currentId);

        if(!favorite)
            return "";

        return favorite.title;
    }

    function addFolder(title, parentid)
    {
        var favoriteid = Favorites.addFolder(title, parentid);

        if(currentId === parentid)
            favoritesmodel.addFolderInView(title, favoriteid, parentid);
    }

    function addUrl(title, url, parentid)
    {
        var favoriteid = Favorites.addUrl(title, url, parentid);

        if(currentId === parentid)
            favoritesmodel.addUrlInView(title, url, favoriteid, parentid);
    }

    function replaceFolder(favoriteid, parentid, title)
    {
        if(currentId === parentid)
        {
            var idx = indexOf(favoriteid);

            if(idx !== -1)
            {
                var favorite = favoritesmodel.get(idx);
                favorite.title = title;
            }
        }

        Favorites.replaceFolder(favoriteid, title);
    }

    function replaceUrl(favoriteid, parentid, title, url)
    {
        if(currentId === parentid)
        {
            var idx = indexOf(favoriteid);

            if(idx !== -1)
            {
                var favorite = favoritesmodel.get(idx);
                favorite.title = title;
                favorite.url = url;
            }
        }

        Favorites.replaceUrl(favoriteid, title, url);
    }

    function erase(favoriteid, parentid)
    {
        if(currentId === parentid)
        {
            var idx = indexOf(favoriteid);

            if(idx !== -1)
                favoritesmodel.remove(idx);
        }

        Favorites.remove(favoriteid);
    }

    function jumpTo(favoriteid)
    {
        currentId = favoriteid;
        Favorites.readChildren(favoriteid, favoritesmodel);
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
}
