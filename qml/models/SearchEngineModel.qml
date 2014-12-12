import QtQuick 2.0

ListModel
{
    id: searchengines

    function indexOf(name)
    {
        for(var i = 0; i < searchengines.count; i++)
        {
            if(name === searchengines.get(i).name)
                return i;
        }

        return -1;
    }
}
