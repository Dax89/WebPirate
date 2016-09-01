import QtQuick 2.1
import "../../../js/UrlHelper.js" as UrlHelper
import "../../../js/youtube/YouTubeGrabber.js" as YouTubeGrabber

QtObject
{
    function handleProtocol(protocol, url)
    {
        if(protocol === "rtsp")
        {
            if(UrlHelper.domainName(webview.url.toString()).indexOf("youtube.com") !== -1) /* Grab YouTube videos if an RTSP url is requested */
            {
                var data = new Object;
                data.videoId = YouTubeGrabber.getVideoId(webview.url.toString());
                listener.dispatchers.playYouTubeVideo(data);
            }

            return true; /* Ignore other RTSP protocol requests */
        }

        if(protocol === "mailto")
        {
            mainwindow.settings.urlcomposer.mailTo(url);
            return true;
        }

        if(protocol === "sms")
        {
            mainwindow.settings.urlcomposer.send(url);
            return true;
        }

        if(protocol === "tel")
        {
            mainwindow.settings.urlcomposer.compose(url);
            return true;
        }

        return false;
    }
}
