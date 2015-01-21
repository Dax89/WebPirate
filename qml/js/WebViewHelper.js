var __webpirate__ = {
    timerid: -1,
    islongpress: false,
    currtouch: null,

    checkLongPress: function(x, y, target) {
        __webpirate__.islongpress = true;
        var rect = target.getBoundingClientRect();

        var data = new Object;
        data.type = "longpress";
        data.x = x;
        data.y = y;
        data.left = rect.left;
        data.top = rect.top;
        data.width = rect.width;
        data.height = rect.height;

        if(target.tagName === "A")
        {
            data.url = target.href;
            data.isimage = false;
        }
        else if(target.parentNode.tagName === 'A')
        {
            data.url = target.parentNode.href;
            data.isimage = false;
        }
        else if(target.tagName === "IMG")
        {
            data.url = target.src;
            data.isimage = true;
        }
        else if(target.textContent)
            data.text = target.innerText;
        else
        {
            var style = window.getComputedStyle(target, null); // Try to get image from CSS

            if(style.backgroundImage)
            {
                data.url = style.backgroundImage.slice(4, -1);
                data.isimage = true;
            }
            else
              return;
        }

        navigator.qt.postMessage(JSON.stringify(data));
    },

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
        ytbtnplay.setAttribute("onclick", "__webpirate__.playRequested('" + videoid + "'); return false;");
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

            var ytplayer = __webpirate__.createPlayer(cap[1]);
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

        var ytplayer = __webpirate__.createPlayer(cap[1]);
        ytplayer.className = "player-width player-height";

        ytplayercontainer.appendChild(ytplayer);
        return true;
    },

    polishDocument: function() {
        canvg(); /* Convert all SVG Images to canvas objects */

        if(!__webpirate__.checkYouTubeVideo())
            __webpirate__.checkEmbeddedYouTubeVideo();
    },

    onTouchStart: function(touchevent) {
        if(touchevent.touches.length === 1)
        {
            __webpirate__.currtouch = touchevent.touches[0];
            __webpirate__.timerid = setTimeout(function() {
                __webpirate__.checkLongPress(__webpirate__.currtouch.clientX, __webpirate__.currtouch.clientY, touchevent.target)
            }, 800);
        }

        var data = new Object;
        data.type = "touchstart";

        navigator.qt.postMessage(JSON.stringify(data));
    },

    onTouchEnd: function(touchevent)
    {
        if(__webpirate__.islongpress)
        {
            __webpirate__.islongpress = false;
            touchevent.preventDefault();
        }

        __webpirate__.currtouch = null;
        clearTimeout(__webpirate__.timerid);
    },

    onTouchMove: function(touchevent) {
        if(__webpirate__.islongpress)
        {
            __webpirate__.islongpress = false;
            touchevent.preventDefault();
        }

        clearTimeout(__webpirate__.timerid);
        __webpirate__.currtouch = null;
    },

    onClick: function(event) {
        var target = event.target;

        if((target.tagName === "A") && target.hasAttribute("target"))
        {
            var data = new Object;
            data.type = "newtab";
            data.url = target.href;

            navigator.qt.postMessage(JSON.stringify(data));
        }
    },

    onSubmit: function(event) {
        var inputelements = event.target.getElementsByTagName("input");

        var logindata = new Object
        logindata.type = "submit";

        for(var i = 0; i < inputelements.length; i++)
        {
            var input = inputelements[i];

            if((input.id === null && input.name === null) || input.value === null || input.value.length === 0)
                continue;

            if(input.type === "text" || input.type === "email")
            {
                logindata.loginattribute = input.id ? "id" : "name";
                logindata.loginid = input.id ? input.id : input.name;
                logindata.login = input.value;

                if(logindata.password)
                    break;
            }
            else if(input.type === "password")
            {
                logindata.passwordattribute = input.id ? "id" : "name";
                logindata.passwordid = input.id ? input.id : input.name;
                logindata.password = input.value;

                if(logindata.login)
                    break;
            }
        }

        if(logindata.loginid && logindata.login && logindata.passwordid && logindata.password)
            navigator.qt.postMessage(JSON.stringify(logindata));
    }
};

document.addEventListener("touchstart", __webpirate__.onTouchStart, true);
document.addEventListener("touchmove",  __webpirate__.onTouchMove, true);
document.addEventListener("touchend",  __webpirate__.onTouchEnd, true);
document.addEventListener("click",  __webpirate__.onClick, true);
document.addEventListener("submit",  __webpirate__.onSubmit, true);
