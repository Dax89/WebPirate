.pragma library

var domainregex = new RegExp("http[s]*://[a-zA-Z0-9-_]*[\\.]*[a-zA-Z0-9-_]+[\\.]*[a-zA-Z0-9-_\\.]*");
var urlregex = new RegExp("[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)");
var specialurlregex = new RegExp("([a-z]+)\\:.+");
var hostportregex = new RegExp("[-a-zA-Z0-9@:%._\\+~#=]{1,256}:[0-9]+");
var ipregex = new RegExp("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}");
var ipportregex = new RegExp("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}:[0-9]+");
var protocolregex = new RegExp("^([^:]+)://");

function adjustUrl(adjurl)
{
    if(isSpecialUrl(adjurl))
        return adjurl;

    if(!protocolregex.test(adjurl))
        return "http://" + adjurl

    return adjurl
}

function domainName(url)
{
    var domain = domainregex.exec(adjustUrl(url));

    if(!domain || domain.length < 1)
        return;

    return domain[0];
}

function urlPath(url)
{
    var idx = url.indexOf("?");

    if(idx !== -1)
        return url.slice(0, idx);

    return url;
}

function protocol(url)
{
    var cap = protocolregex.exec(url);

    if(!cap || (cap && !cap[1])) {
        cap = specialurlregex.exec(url);

        if(!cap || (cap && !cap[1]))
            return "http"; /* Fallback to HTTP */

        return cap[1];
    }

    return cap[1];
}

function filePath(url)
{
    var idx = url.indexOf("file://");

    if(idx !== -1)
        return url.slice(7);

    return url;
}

function isUrl(url)
{
    return urlregex.test(url) || ipregex.test(url) || ipportregex.test(url) || hostportregex.test(url);
}

function isSpecialUrl(url)
{
    return url.indexOf("about:") === 0;
}

function specialUrl(url)
{
    return url.split(":")[1];
}

function decode(url)
{
    return decodeURIComponent(url.replace(/\+/g, "%20"));
}

function printable(url)
{
    return url.replace(/ /g, "%20");
}
