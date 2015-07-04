var __wp_grabberbuilder__ = {
    cleanElement: function(element) {
        while(element.firstChild)
            element.removeChild(element.firstChild);
    },

    escape: function(s) {
        return s.replace(/'/g, "&#39;");
    },

    unescape: function(s) {
        return s.replace("&#39;", "'");
    },

    createPlayer: function(element, playername, clickevent, iconurl) {
        if(!element)
            return null;

        var rect = element.getBoundingClientRect();
        __wp_grabberbuilder__.cleanElement(element);

        var player = document.createElement("DIV");
        player.id = "__wp_" + playername + "_player__";
        player.style.backgroundColor = "#1b1b1b";
        player.style.width = rect.width + "px";
        player.style.height = rect.height + "px";

        var btnplay = document.createElement("A");
        btnplay.id = "__wp_" + playername + "_playbutton__";
        btnplay.href = "#";
        btnplay.setAttribute("onclick", clickevent + "; return false;");
        btnplay.style.display = "block";
        btnplay.style.width = "inherit";
        btnplay.style.height = "inherit";

        if(iconurl)
            btnplay.style.background = "url('" + iconurl + "') 50% 50% / 50% no-repeat";

        player.appendChild(btnplay);

        if(element.tagName === "IFRAME")
            element.outerHTML = player.outerHTML;
        else
            element.appendChild(player);

        return player;
    }
}
