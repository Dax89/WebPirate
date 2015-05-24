var __wp_jwplayerhelper__ = {
    getEmbeddedVideos: function() {
        if(!("jwplayer" in window))
            return;

        var jwplayerinstance = window.jwplayer();
        var element = document.getElementById(jwplayerinstance.id);
        var anchors = element.getElementsByTagName("a");

        /* JWPlayer goes in Fallback mode and give us
         * an <a> tag in order to execute our video */
        for(var i = 0; anchors.length; i++)
            anchors[i].setAttribute("__wp_video__", true);

        element.setAttribute("__wp_video__", true);
    }
};
