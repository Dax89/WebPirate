.pragma library

.import "UrlHelper.js" as UrlHelper

function grabVideoUrl(videoid)
{
    return  "http://www.youtube.com/get_video_info?video_id=" + videoid + "&el=vevo&el=embedded";
}

function decodeVideoTypes(videolist, mediagrabber)
{
    var urlregex = new RegExp("url\\=([^&]+)");
    var typeregex = new RegExp("type\\=[^&]+");
    var mimeregex = new RegExp("type\\=([^;]+)");
    var qualityregex = new RegExp("quality\\=([^&]+)");
    var codecregex = new RegExp("codecs\\=\"([^\"]+)\"");

    videolist = UrlHelper.decode(videolist).split(",");

    for(var i = 0; i < videolist.length; i++)
    {
        var videotype = UrlHelper.decode(typeregex.exec(videolist[i])[0]);
        var cap = codecregex.exec(videotype);

        var videoinfo = { "url": UrlHelper.decode(urlregex.exec(videolist[i])[1]),
                          "mime": mimeregex.exec(videotype)[1],
                          "hascodec": cap !== null,
                          "codec": cap ? cap[1] : "",
                          "quality": qualityregex.exec(videolist[i])[1] };

        mediagrabber.addVideo(qsTr("Quality") + ": " + (videoinfo.quality + " (" + videoinfo.mime + (videoinfo.hascodec ? (", " + videoinfo.codec) : "") + ")"),
                              videoinfo.mime, videoinfo.url);
    }
}

function grabVideo(videoid, mediagrabber)
{
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var videoinfo = req.responseText.split("&");

            for(var i = 0; i < videoinfo.length; i++)
            {
                var videoentry = videoinfo[i].split("=");

                if((videoentry[0] === "status") && (videoentry[1] === "fail"))
                    mediagrabber.grabFailed = true;
                else if(videoentry[0] === "reason")
                    mediagrabber.videoResponse = UrlHelper.decode(videoentry[1]);

                if(mediagrabber.grabFailed && mediagrabber.grabResult.length)
                    break;

                if(mediagrabber.grabFailed)
                    continue;

                if(videoentry[0] === "author")
                    mediagrabber.videoAuthor = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "title")
                    mediagrabber.videoTitle = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "iurl")
                    mediagrabber.videoThumbnail = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "length_seconds")
                    mediagrabber.videoDuration = parseInt(videoentry[1]);
                else if(videoentry[0] === "url_encoded_fmt_stream_map")
                    decodeVideoTypes(videoentry[1], mediagrabber);
            }
        }
    };

    req.open("GET", grabVideoUrl(videoid));
    req.send();
}
