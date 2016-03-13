// Thanks llelectronics for this great idea! :)

var __wp_tagoverrider_ = {
    supportedmedias: [ "video/mp4", "video/ogg", "audio/mpeg", "audio/ogg", "audio/mp4",
                       "application/vnd.apple.mpegURL", "application/x-mpegURL", "audio/mpegurl" ],

    ignoreplayback: false,

    saveTag: function(touchevent) {
        var element = touchevent.target;

        console.log(element.tagName);

        if(element.tagName !== "VIDEO")
            return;

        __wp_tagoverrider_.clickedvideo = element;
    },

    playVideo: function(src) {
        var data = { type: "play_video", url: src };
        navigator.qt.postMessage(JSON.stringify(data));
    }
};

document.createElement("video").constructor.prototype.buffered = function () {
    return { length: 0, start: 0, end: 1 };
}

document.createElement("video").constructor.prototype.pause = function() { /* Dummy */ }
document.createElement("video").constructor.prototype.load = function() { /* Dummy */ }

document.createElement("video").constructor.prototype.play = function() {
    if(__wp_tagoverrider_.ignoreplayback) {
        return;
    }

    var videosrc = (this.src || this.getAttribute("src"));

    __wp_tagoverrider_.ignoreplayback = true;
    setTimeout(function() { __wp_tagoverrider_.ignoreplayback = false; }, 1500);
    __wp_tagoverrider_.playVideo(videosrc);
}

document.createElement("video").constructor.prototype.canPlayType = function(media) {
    for(var i = 0; i < __wp_tagoverrider_.supportedmedias.length; i++) {
        if(media.indexOf(__wp_tagoverrider_.supportedmedias[i]) !== -1)
            return "probably";
    }

    return "";
}
