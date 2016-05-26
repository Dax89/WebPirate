window.WebPirate_VimeoHandlerObject = WebPirate.inherit(WebPirate_GrabberBuilderObject, function() {
    this.touchGrab("vimeo.com", this.grabVideo.bind(this));
});

window.WebPirate_VimeoHandlerObject.prototype.grabVideo = function(element) {
    if((element.tagName === "DIV") && WebPirate.hasClass(element, "target"))
        element = element.parentElement;

    if(element.tagName !== "DIV" && !element.hasAttribute("data-config-url"))
        return;

    WebPirate.get(element.getAttribute("data-config-url"), function(videodata) {
        var data = { "title": WebPirate_Utils.escape(videodata.video.title),
                     "author": WebPirate_Utils.escape(videodata.video.owner.name),
                     "thumbnail": videodata.video.thumbs.base,
                     "duration" : videodata.video.duration };


        var videos = videoconfig.request.files.progressive;
        data.video = new Array;

        for(var i = 0; i < videos.length; i++)
            data.videos.push({ "type": videos[i].quality + ", " + videos[i].mime, "url": videos[i].url });

        this.sendPlay("vimeohandler", data);

    }, null, null, "json");
};

window.WebPirate_VimeoHandler = new window.WebPirate_VimeoHandlerObject();
