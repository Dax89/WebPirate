import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/UrlHelper.js" as UrlHelper

Image
{
    property string site

    id: favicon
    cache: true
    asynchronous: true
    width: Theme.iconSizeSmall
    height: Theme.iconSizeSmall
    fillMode: Image.PreserveAspectFit

    onSiteChanged: {
        var domainname = UrlHelper.domainName(site)
        var req = new XMLHttpRequest();

        req.onreadystatechange = function() {
            if((req.readyState === XMLHttpRequest.DONE) && (req.status === 200)) {
                var regex = new RegExp("<link.*rel[ ]*=[ ]*[\\\"\\\'][ ]*shortcut[ ]+icon[ ]*[\\\"\\\'][^>]+>", "i");
                var linktag = regex.exec(req.responseText);

                if(linktag === null)
                {
                    source = "image://theme/icon-m-favorite";
                    return;
                }

                regex = new RegExp("href[ ]*=[ ]*[\\\"\\\']([^\\\"\\\']+)[\\\"\\\']", "i");
                var link = regex.exec(linktag[0]);

                if(link === null)
                {
                    source = "image://theme/icon-m-favorite";
                    return;
                }

                if(link[1].indexOf(domainname) === 0)
                    source = UrlHelper.adjustUrl(link[1]);
                else
                    source = domainname + "/" + link[1];
            }
            else
                source = "image://theme/icon-m-favorite";
        }

        if(domainname === null)
        {
            source = "image://theme/icon-m-favorite";
            return;
        }

        req.open("GET", domainname, true);
        req.send();
    }

    onStatusChanged: {
        if(status === Image.Error)
            source = "image://theme/icon-m-favorite";
    }
}
