var __wp_dailymotionhelper__ = {

    playRequested: function(videoinfo) {
        navigator.qt.postMessage(videoinfo);
    },

    grabVideo: function() {
        var dmplayer = document.querySelector("iframe[class='video-player']");

        if(!dmplayer)
            return;

        var regex = new RegExp("stream_([^_])+_url\":[\\s]*\"([^\"]+)\"", "g");
        var dminfo = f.contentWindow.info;
        var dminfostring = JSON.stringify(dminfo);

        var videoinfo = new Object;
        videoinfo.type = "play_dailymotion";
        videoinfo.title = dminfo.title;
        videoinfo.thumbnail = dminfo.thumbnail_url;
        videoinfo.quality = new Array;

        var cap = null;

        while((cap = regex.exec(dminfostring)))
            videoinfo.quality.push({ "type": cap[1], "url": cap[2] });

        __wp_grabberbuilder__.createPlayer(dmplayer, "dm", "__wp_dailymotionhelper__.playRequested('" + JSON.stringify(videoinfo) + "')", __wp_dailymotionhelper__.playbutton);
    }
};
