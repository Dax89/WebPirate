var __wp_vimeohelper__ = {
    grabVideo: function(videoconfig) {
        var vimeoinfo = new Object;
        vimeoinfo.type = "play_vimeo";
        vimeoinfo.title = __wp_utils__.escape(videoconfig.video.title);
        vimeoinfo.author = __wp_utils__.escape(videoconfig.video.owner.name);
        vimeoinfo.thumbnail = videoconfig.video.thumbs.base;
        vimeoinfo.duration = videoconfig.video.duration;
        vimeoinfo.videos = new Array;

        var videos = videoconfig.request.files.progressive;

        for(var i = 0; i < videos.length; i++)
            vimeoinfo.videos.push({"type": videos[i].quality + ", " + videos[i].mime, "url": videos[i].url });

        navigator.qt.postMessage(JSON.stringify(vimeoinfo));
    },

    clickGrab: function(touchevent) {
        var vmvideoelement = touchevent.target;

        if((vmvideoelement.tagName === "DIV") && (vmvideoelement.className.split(" ").indexOf("target") !== -1))
            vmvideoelement = vmvideoelement.parentElement;

        if((vmvideoelement.tagName !== "DIV") || !vmvideoelement.hasAttribute("data-config-url"))
            return;

        var req = new XMLHttpRequest;

        req.onreadystatechange = function() {
            if(req.readyState === XMLHttpRequest.DONE) {
                var videoconfig = JSON.parse(req.responseText);
                __wp_vimeohelper__.grabVideo(videoconfig);
            }
        }

        req.open("GET", vmvideoelement.getAttribute("data-config-url"));
        req.send();
    }
};

if(__wp_utils__.getDomain() === "vimeo.com")
    document.addEventListener("touchend",  __wp_vimeohelper__.clickGrab, true);
