var __wp_videohelper__ = {
    helpers: { "youtube.com": __wp_youtubehelper__,
               "dailymotion.com": __wp_dailymotionhelper__ },

    getVideo: function() {
        var helper = __wp_videohelper__.helpers[__wp_utils__.getDomain()];

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
