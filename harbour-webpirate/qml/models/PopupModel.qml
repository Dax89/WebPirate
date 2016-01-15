import QtQuick 2.1

ListModel
{
    id: popupmodel

    function populate(sqlrows)
    {
        popupmodel.clear();

        for(var i = 0; i < sqlrows.length; i++)
        {
            var row = sqlrows[i];
            addRule(row.domain, row.popuprule);
        }
    }

    function addRule(domain, rule)
    {
        popupmodel.append({ "domain": domain, "popuprule": rule });
    }
}
