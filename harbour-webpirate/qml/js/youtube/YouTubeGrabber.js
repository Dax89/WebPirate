.pragma library

.import "../UrlHelper.js" as UrlHelper
.import "YouTubeCipher.js" as YouTubeCipher

function getVideoId(url)
{
    var cap = /^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*/.exec(url);

    if(!cap || !cap[1])
        return null;

    return cap[1];
}

function grabVideoUrl(videoid)
{
    return  "https://www.youtube.com/get_video_info?video_id=" + videoid + "&el=vevo&el=embedded&el=detailpage&asv=3";
}

function decodeVideoTypes(videolist, mediagrabber, decodefunc)
{
    var urlregex = new RegExp("url\\=([^&]+)");
    var typeregex = new RegExp("type\\=[^&]+");
    var mimeregex = new RegExp("type\\=([^;]+)");
    var qualityregex = new RegExp("quality\\=([^&]+)");
    var codecregex = new RegExp("codecs\\=\"([^\"]+)\"");

    videolist = videolist.split(",");

    for(var i = 0; i < videolist.length; i++)
    {
        mediagrabber.grabStatus = qsTr("Grabbing %1").arg(i + 1);

        var videotype = UrlHelper.decode(typeregex.exec(videolist[i])[0]);
        var cap = codecregex.exec(videotype);

        var videoinfo = { "url": UrlHelper.decode(urlregex.exec(videolist[i])[1]),
                          "mime": mimeregex.exec(videotype)[1],
                          "hascodec": cap !== null,
                          "codec": cap ? cap[1] : "",
                          "quality": qualityregex.exec(videolist[i])[1] };

        if(decodefunc)
        {
            var signature = /s=([A-F0-9]+\.[A-F0-9]+)/.exec(videolist[i]);

            if(signature && signature[1])
            {
                mediagrabber.grabStatus = qsTr("Decoding Signature for %1").arg(i + 1);
                videoinfo.url += "&signature=" + decodefunc(signature[1]);
            }
        }

        mediagrabber.addVideo(qsTr("Quality") + ": " + (videoinfo.quality + " (" + videoinfo.mime + (videoinfo.hascodec ? (", " + videoinfo.codec) : "") + ")"),
                              videoinfo.mime, videoinfo.url);
    }

    mediagrabber.grabStatus = qsTr("Video grabbed successfully");
    mediagrabber.grabFailed = false;
    mediagrabber.grabbing = false;
}

function grabVideo(videoid, mediagrabber)
{
    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var ciphered = false;
            var videoinfo = req.responseText.split("&");

            mediagrabber.grabbing = true;
            mediagrabber.grabStatus = qsTr("Downloading video info");

            for(var i = 0; i < videoinfo.length; i++)
            {
                var videoentry = videoinfo[i].split("=");

                if((videoentry[0] === "status") && (videoentry[1] === "fail"))
                {
                    mediagrabber.grabFailed = true;
                    mediagrabber.grabStatus = qsTr("Cannot get video, report to developer");
                }
                else if(videoentry[0] === "reason")
                    mediagrabber.grabStatus = UrlHelper.decode(videoentry[1]);

                if(mediagrabber.grabFailed && mediagrabber.grabResult.length)
                {
                    mediagrabber.grabbing = false;
                    break;
                }

                if(mediagrabber.grabFailed)
                    continue;

                /* It's a Ciphered Video? If yes we need to decode it by parsing the WebPage */
                if((videoentry[0] === "use_cipher_signature") && (videoentry[1] === "True"))
                {
                    ciphered = true;
                    YouTubeCipher.decodeCipheredVideo(videoid, mediagrabber, decodeVideoTypes);
                    continue;
                }

                if(videoentry[0] === "author")
                    mediagrabber.videoAuthor = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "title")
                    mediagrabber.videoTitle = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "iurl")
                    mediagrabber.videoThumbnail = UrlHelper.decode(videoentry[1]);
                else if(videoentry[0] === "length_seconds")
                    mediagrabber.videoDuration = parseInt(videoentry[1]);
                else if(!ciphered && (videoentry[0] === "url_encoded_fmt_stream_map"))
                    decodeVideoTypes(UrlHelper.decode(videoentry[1]), mediagrabber);
            }
        }
    };

    req.open("GET", grabVideoUrl(videoid));
    req.send();
}
