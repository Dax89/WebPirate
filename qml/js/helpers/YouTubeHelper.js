var __yt_webpirate__ = {

    playRequested: function(videoid) {
        var data = new Object;
        data.type = "youtube_play";
        data.videoid = videoid;

        navigator.qt.postMessage(JSON.stringify(data));
    },

    createPlayer: function(videoid) {
        var ytplayer = document.createElement("div")
        ytplayer.id = "__wp_ytplayer__";
        ytplayer.style.backgroundColor = "#1b1b1b";

        var ytbtnplay = document.createElement("A");
        ytbtnplay.id = "__wp_ytplaybutton__";
        ytbtnplay.href = "#";
        ytbtnplay.style.display = "block";
        ytbtnplay.style.width = "inherit";
        ytbtnplay.style.height = "inherit";
        ytbtnplay.style.background = "url(https://www.youtube.com/yt/brand/media/image/YouTube-icon-full_color.png) 50% 50% / 50% no-repeat";
        ytbtnplay.setAttribute("onclick", "__yt_webpirate__.playRequested('" + videoid + "'); return false;");
        ytplayer.appendChild(ytbtnplay);

        return ytplayer;
    },

    checkEmbeddedYouTubeVideo: function() {
        var iframes = document.getElementsByTagName("iframe");

        if(!iframes.length)
            return;

        var ytregex = new RegExp("www\\.youtube\\.[^/]+/embed/([^/]+)");

        for(var i = 0; i < iframes.length; i++)
        {
            var iframe = iframes[i];
            var cap = ytregex.exec(iframe.src);

            if(!cap || (cap && !cap[1]))
                continue;

            var ytplayer = __yt_webpirate__.createPlayer(cap[1]);
            ytplayer.style.width = iframe.width + "px";
            ytplayer.style.height = iframe.height + "px";

            iframe.outerHTML = ytplayer.outerHTML;
        }
    },

    checkYouTubeVideo: function() {
        var location = document.location;

        if((location.hostname.indexOf("www.youtube") !== 0) || (location.pathname !== "/watch") || (location.search.indexOf("?v=") !== 0))
            return false;

        var ytplayercontainer = document.getElementById("player-mole-container");

        if(!ytplayercontainer)
            return false;

        while(ytplayercontainer.firstChild)
          ytplayercontainer.removeChild(ytplayercontainer.firstChild)

        // Remove this element so we can click the link
        var thbackground = document.getElementById("theater-background");

        if(thbackground)
            thbackground.parentNode.removeChild(thbackground);

        ytplayercontainer.className = "player-width player-height";
        ytplayercontainer.style.backgroundColor = "#1b1b1b";

        var ytregex = new RegExp("www\\.youtube\\.[^/]+/watch\\?v\\=([^&]+)");
        var cap = ytregex.exec(location.href);

        if(!cap || (cap && !cap[1]))
            return false;

        var ytplayer = __yt_webpirate__.createPlayer(cap[1]);
        ytplayer.className = "player-width player-height";

        ytplayercontainer.appendChild(ytplayer);
        return true;
    },

    convertVideo: function() {
        if(!__yt_webpirate__.checkYouTubeVideo())
            __yt_webpirate__.checkEmbeddedYouTubeVideo();
    }
}
