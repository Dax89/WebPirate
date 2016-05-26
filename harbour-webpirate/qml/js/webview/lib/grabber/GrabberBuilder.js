window.WebPirate_GrabberBuilderObject = function() {

};

window.WebPirate_GrabberBuilderObject.prototype.ignite = function() {
    WebPirate.timeout(function() {
        var getvideo = (typeof this.getVideo === "function");
        var res = false;

        if(getvideo)
            res = this.getVideo();

        if(!res && (typeof this.getEmbeddedVideos === "function"))
            this.getEmbeddedVideos();
    }, 1000, this);
}

window.WebPirate_GrabberBuilderObject.prototype.sendPlay = function(playername, data) {
    WebPirate.postMessage(playername + "_play", data);
}

window.WebPirate_GrabberBuilderObject.prototype.cleanElement = function(element) {
    while(element.firstChild)
        element.removeChild(element.firstChild);
};

window.WebPirate_GrabberBuilderObject.prototype.createPlayer = function(element, playername, data, iconurl, backgroundimage) {
    if(typeof element !== "object")
        return null;

    var date = Date.now();
    var rect = element.getBoundingClientRect();

    this.cleanElement(element);

    var player = document.createElement("DIV");
    player.id = "__wp_" + playername + "_player" + date + "__";
    player.style.width = rect.width + "px";
    player.style.height = rect.height + "px";

    if(typeof backgroundimage === "string") {
        player.style.backgroundImage = "url(" + backgroundimage + ")";
        player.style.backgroundSize = "cover";
        player.style.backgroundRepeat = "no-repeat";
        player.style.backgroundPosition = "center center";
    }
    else
        player.style.backgroundColor = "#1b1b1b";

    var btnplay = document.createElement("A");
    btnplay.id = "__wp_" + playername + "_playbutton" + date + "__";
    btnplay.href = "#";
    btnplay.style.display = "block";
    btnplay.style.width = "inherit";
    btnplay.style.height = "inherit";

    btnplay.addEventListener("click", function(clickevent) {
        clickevent.preventDefault();
        this.sendPlay(playername, data);
    }.bind(this));

    if(typeof iconurl === "string")
        btnplay.style.background = "url('" + iconurl + "') 50% 50% / 50% no-repeat";

    player.appendChild(btnplay);

    if(element.tagName === "IFRAME")
        element.outerHTML = player.outerHTML;
    else
        element.appendChild(player);

    return player;
};

window.WebPirate_GrabberBuilderObject.prototype.touchGrab = function(domainrgx, callback) {
    if((typeof callback !== "function") || !WebPirate.isDomain(domainrgx))
        return;

    document.addEventListener("touchend", function(touchevent) {
        callback(touchevent.target);
    }, true);
};
