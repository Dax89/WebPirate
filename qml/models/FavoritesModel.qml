import QtQuick 2.0
import "../js/UrlHelper.js" as UrlHelper

ListModel
{
    id: favorites

    function contains(url)
    {
        if((url.length === 0) || UrlHelper.isSpecialUrl(url) || !UrlHelper.isUrl(url))
            return false;

        for(var i = 0; i < favorites.length; i++)
        {
            if(url === favorites[i].url)
                return true;
        }

        return false;
    }
}
