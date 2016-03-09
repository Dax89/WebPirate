var __wp_facebookhelper__ = {
    clickGrab: function(touchevent) {
        var fbvideoelement = touchevent.target;

        if((fbvideoelement.tagName === "DIV") && (fbvideoelement.hasAttribute("data-sigil")))
            fbvideoelement = fbvideoelement.parentElement;

        if((fbvideoelement.tagName === "I") && (fbvideoelement.hasAttribute("data-sigil")))
            fbvideoelement = fbvideoelement.parentElement;

        if((fbvideoelement.tagName !== "DIV") || !fbvideoelement.hasAttribute("data-store"))
            return;

        var videoobj = JSON.parse(fbvideoelement.getAttribute("data-store"));

        if(!videoobj.hasOwnProperty("videoID") || !videoobj.hasOwnProperty("src"))
            return;

        var data = new Object;
        data.type = "play_video";
        data.url = videoobj.src;

        navigator.qt.postMessage(JSON.stringify(data));
    }
};

if(__wp_utils__.getDomain() === "facebook.com")
    document.addEventListener("touchend",  __wp_facebookhelper__.clickGrab, true);
