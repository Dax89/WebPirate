// Thanks llelectronics for this great idea! :)

var __wp_tagoverrider__ = {
    supportedmedias: [ "video/mp4", "video/ogg", "audio/mpeg", "audio/ogg", "audio/mp4",
                       "application/vnd.apple.mpegURL", "application/x-mpegURL", "audio/mpegurl" ],
};

document.createElement("video").constructor.prototype.pause = function() { /* Dummy */ }
document.createElement("video").constructor.prototype.load = function() { /* Dummy */ }
document.createElement("video").constructor.prototype.paused = function() { return true; }
document.createElement("video").constructor.prototype.autoplay = function() { return false; }
document.createElement("video").constructor.prototype.readyState = function() { return 1; }
document.createElement("video").constructor.prototype.buffered = function () { return { length: 0 }; }

document.createElement("video").constructor.prototype.play = function() {
    var data = { type: "play_video", url: (this.src || this.getAttribute("src")) };
    navigator.qt.postMessage(JSON.stringify(data));
}

document.createElement("video").constructor.prototype.canPlayType = function(media) {
    for(var i = 0; i < __wp_tagoverrider__.supportedmedias.length; i++) {
        if(media.indexOf(__wp_tagoverrider__.supportedmedias[i]) !== -1)
            return "probably";
    }

    return "";
}

