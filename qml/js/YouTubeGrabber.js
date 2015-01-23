.pragma library

.import "UrlHelper.js" as UrlHelper

var ytregex = new RegExp("www\\.youtube\\.[^/]+/watch\\?v\\=([^&]+)");

function isYouTubeVideo(url)
{
    return ytregex.test(url);
}

function grabVideoId(url)
{
    var matches = ytregex.exec(url);

    if(matches.length < 2)
        return null;

    return matches[1];
}

function grabVideoUrl(videoid)
{
    return  "http://www.youtube.com/get_video_info?video_id=" + videoid + "&el=vevo&el=embedded";
}

function decodeVideoTypes(videolist, videoTypesModel)
{
    var urlregex = new RegExp("url\\=([^&]+)");
    var typeregex = new RegExp("type\\=[^&]+");
    var mimeregex = new RegExp("type\\=([^;]+)");
    var qualityregex = new RegExp("quality\\=([^&]+)");
    var codecregex = new RegExp("codecs\\=\"([^\"]+)\"");

    videoTypesModel.clear();
    videolist = UrlHelper.decode(videolist).split(",");

    for(var i = 0; i < videolist.length; i++)
    {
        var videotype = UrlHelper.decode(typeregex.exec(videolist[i])[0]);
        var cap = codecregex.exec(videotype);

        videoTypesModel.append({ "url": UrlHelper.decode(urlregex.exec(videolist[i])[1]),
                                 "mime": mimeregex.exec(videotype)[1],
                                 "hascodec": cap !== null,
                                 "codec": cap ? cap[1] : "",
                                 "quality": qualityregex.exec(videolist[i])[1] });
    }
}

function pad(num, size)
{
    var s = num + "";

    while(s.length < size)
        s = "0" + s;

    return s;
}

function displayDuration(duration)
{
    var numdays = Math.floor(duration / 86400);
    var numhours = Math.floor((duration % 86400) / 3600);
    var numminutes = Math.floor(((duration % 86400) % 3600) / 60);
    var numseconds = ((duration % 86400) % 3600) % 60;

    var videoduration = "";

    if(numdays > 0)
        videoduration += pad(numdays, 2) + ":";

    if(numhours > 0)
        videoduration += pad(numhours, 2) + ":";

    videoduration += pad(numminutes, 2) + ":";
    videoduration += pad(numseconds, 2);

    return videoduration;
}

function grabVideo(videoid, ytvideosettings)
{
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var videoinfo = req.responseText.split("&");

            for(var i = 0; i < videoinfo.length; i++)
            {
                var videoentry = videoinfo[i].split("=");

                if((videoentry[0] === "status") && (videoentry[1] === "fail"))
                    break; //FIXME: (YouTube) Grab Error Message
                else if(videoentry[0] === "author")
                    ytvideosettings.videoAuthor = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "title")
                    ytvideosettings.videoTitle = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "iurl")
                    ytvideosettings.videoThumbnail = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "length_seconds")
                    ytvideosettings.videoDuration = displayDuration(parseInt(videoentry[1]));
                else if(videoentry[0] === "url_encoded_fmt_stream_map")
                    decodeVideoTypes(videoentry[1], ytvideosettings.videoTypes);
            }
        }
    };

    req.open("GET", grabVideoUrl(videoid));
    req.send();
}
