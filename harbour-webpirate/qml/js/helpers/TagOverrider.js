// Thanks llelectronics for this great idea! :)

var __wp_tagoverrider_ = {
    supportedMedias: [ "video/mp4", "video/ogg", "audio/mpeg", "audio/ogg", "audio/mp4",
                       "application/vnd.apple.mpegURL", "application/x-mpegURL", "audio/mpegurl" ]
};

document.createElement("video").constructor.prototype.play = function() {
    var data = { "type": "html5_media_play", "url": this.src };

    navigator.qt.postMessage(JSON.stringify(data));
}

document.createElement("video").constructor.prototype.canPlayType = function(media) {
    for(var i = 0; i < __wp_tagoverrider_.supportedMedias.length; i++) {
        if(media.indexOf(__wp_tagoverrider_.supportedMedias[i]) !== -1)
            return "probably";
    }

    return "";
}
