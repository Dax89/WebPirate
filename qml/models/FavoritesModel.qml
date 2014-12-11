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
}
