var __wp_videohelper__ = {
    domainregex: /[www|m]*[0-9]*[\.]*([^$/:]+)/,

    helpers: { "youtube.com": __wp_youtubehelper__,
               "dailymotion.com": __wp_dailymotionhelper__,
               "vimeo.com": __wp_vimeohelper__ },

    getDomain: function() {
        var domain = document.location.hostname;
        var cap = __wp_videohelper__.domainregex.exec(domain);

        if(cap && cap[1])
            return cap[1];

        return domain;
    },

    getVideo: function() {
        var helper = __wp_videohelper__.helpers[__wp_videohelper__.getDomain()];

        setTimeout(function() {
            if(!helper) {
                __wp_videohelper__.getEmbeddedVideos();
                return;
            }

            helper.getVideo();
        }, 1000);
    },

    getEmbeddedVideos: function() {
        __wp_youtubehelper__.getEmbeddedVideos();
        __wp_jwplayerhelper__.getEmbeddedVideos();
    }
};
