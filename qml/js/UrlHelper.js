.pragma library

function adjustUrl(adjurl)
{
    if(isSpecialUrl(adjurl))
        return adjurl;

    var regex = new RegExp("^(http|https)://")

    if(!regex.test(adjurl))
        return "http://" + adjurl

    return adjurl
}

function domainName(url)
{
    var regex = new RegExp("http[s]*://[a-zA-Z0-9-_]*[\\.]*[a-zA-Z0-9-_]+\\.[a-zA-Z0-9-_\\.]+");
    return regex.exec(adjustUrl(url))[0];
}

function isUrl(url)
{
    var regex = new RegExp("[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)");
    return regex.test(url);
}

function isSpecialUrl(url)
{
    return url.indexOf("about:") === 0;
}

function specialUrl(url)
{
    return url.split(":")[1];
}
