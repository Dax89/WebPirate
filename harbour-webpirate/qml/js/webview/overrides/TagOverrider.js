// Thanks llelectronics for this great idea! :)

window.WebPirate_TagOverriderObject = function() {
    this.supportedmedias = [ "video/mp4", "video/ogg", "audio/mpeg", "audio/ogg", "audio/mp4",
                             "application/vnd.apple.mpegURL", "application/x-mpegURL", "audio/mpegurl" ];

    document.createElement("video").constructor.prototype.pause = function() { /* Dummy */ }
    document.createElement("video").constructor.prototype.load = function() { /* Dummy */ }
    document.createElement("video").constructor.prototype.paused = function() { return true; }
    document.createElement("video").constructor.prototype.autoplay = function() { return false; }
    document.createElement("video").constructor.prototype.readyState = function() { return 1; }
    document.createElement("video").constructor.prototype.buffered = function () { return { length: 0 }; }

    document.createElement("video").constructor.prototype.play = function() {
        var data = { type: "tagoverrider_play", data: { url: (this.src || this.getAttribute("src")) } };
        navigator.qt.postMessage(JSON.stringify(data));
    }

    document.createElement("video").constructor.prototype.canPlayType = function(media) {
        for(var i = 0; i < WebPirate_TagOverrider.supportedmedias.length; i++) {
            if(media.indexOf(WebPirate_TagOverrider.supportedmedias[i]) !== -1)
                return "probably";
        }

        return "";
    }
};

window.WebPirate_TagOverrider = new window.WebPirate_TagOverriderObject();
