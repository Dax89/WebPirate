import QtQuick 2.0
import "../js/UrlHelper.js" as UrlHelper

ListModel
{
    id: favorites

    function indexOf(url)
    {
        for(var i = 0; i < favorites.count; i++)
        {
            if(url === favorites.get(i).url)
                return i;
        }

        return -1;
    }

    function contains(url)
    {
        if((url.length === 0) || UrlHelper.isSpecialUrl(url) || !UrlHelper.isUrl(url))
            return false;

        return indexOf(url) !== -1;
    }

    function fetchIcon(url, favorite)
    {
        var domainname = UrlHelper.domainName(url);
        var req = new XMLHttpRequest();

        favorite.icon = "image://theme/icon-m-favorite"

        req.onreadystatechange = function() {
            if((req.readyState === XMLHttpRequest.DONE) && (req.status === 200)) {
                var regex = new RegExp("<link.*rel[ ]*=[ ]*[\\\"\\\'][ ]*shortcut[ ]+icon[ ]*[\\\"\\\'][^>]+>", "i");
                var linktag = regex.exec(req.responseText);

                if(linktag === null)
                    return;

                regex = new RegExp("href[ ]*=[ ]*[\\\"\\\']([^\\\"\\\']+)[\\\"\\\']", "i");
                var link = regex.exec(linktag[0]);

                if(link === null)
                    return;

                if(link[1].indexOf(domainname) === 0)
                    favorite.icon = UrlHelper.adjustUrl(link[1]);
                else
                    favorite.icon = domainname + "/" + link[1];
            }
        }

        if(domainname === null)
            return;

        req.open("GET", domainname);
        req.send();
    }
}
