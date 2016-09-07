window.WebPirate_TouchHandlerObject = function() {
    this.LONG_PRESS_TIMEOUT = 800;
    this.islongpress = false;
    this.currenttouch = null;
    this.timerid = -1;
    this.lastY = -1;

    document.addEventListener("touchstart", this.onTouchStart.bind(this), true);
    document.addEventListener("touchmove",  this.onTouchMove.bind(this), true);
    document.addEventListener("touchend",  this.onTouchEnd.bind(this), true);
};

window.WebPirate_TouchHandlerObject.prototype.findAnchorAncestor = function(element) {
    var currelement = element;

    while(currelement) {
        if(currelement.tagName === "BODY")
            return null;

        if(currelement.tagName === "A")
            break;

        currelement = currelement.parentNode;
    }

    return currelement;
};

window.WebPirate_TouchHandlerObject.prototype.sendLongPress = function(target) {
    this.islongpress = true;

    var anchorelement = this.findAnchorAncestor(target);
    var data = { };

    if(anchorelement) {
        data.title = "";
        data.url = anchorelement.href;
        data.isImage = false;
    }
    else if(target.tagName === "IMG") {
        data.title = target.alt || target.src;
        data.url = target.src;
        data.isImage = true;
    }
    else if(target.textContent.length > 0) {
        WebPirate_TextSelectorHandler.select(this.currenttouch.clientX, this.currenttouch.clientY);
        return;
    }
    else {
        var style = window.getComputedStyle(target, null); // Try to get image from CSS

        if(style.backgroundImage !== "none") {
            data.url = style.backgroundImage.slice(4, -1);
            data.isImage = true;
        }
        else
            return;
    }

    WebPirate.postMessage("touchhandler_longpress", data);
};

window.WebPirate_TouchHandlerObject.prototype.onTouchStart = function(touchevent) {
    if(touchevent.touches.length > 1) { // Ignore multi touch
        touchevent.preventDefault();
        return;
    }

    if(touchevent.target.tagName === "SELECT") {
        WebPirate.postMessage("touchhandler_select", { "selectedIndex": touchevent.target.selectedIndex });
        return;
    }

    this.currenttouch = touchevent.touches[0];
    this.lastY = this.currenttouch.clientY;
    this.timerid = WebPirate.timeout(function() { this.sendLongPress(touchevent.target) }, this.LONG_PRESS_TIMEOUT, this);
};

window.WebPirate_TouchHandlerObject.prototype.onTouchMove = function(touchevent) {
    if(this.islongpress) {
        this.islongpress = false;
        touchevent.preventDefault();
    }

    clearTimeout(this.timerid)
    this.lastY = touchevent.touches[0].clientY;
    this.currenttouch = null;

};

window.WebPirate_TouchHandlerObject.prototype.onTouchEnd = function(touchevent) {
    clearTimeout(this.timerid)
    this.currenttouch = null;

    if(!this.islongpress) {
        var target = this.findAnchorAncestor(touchevent.target);

        if(!target || !target.hasAttribute("target"))
            return;

        var href = target.getAttribute("href");

        if((target.getAttribute("target") === "_blank") && (href.length > 0)) {
            touchevent.preventDefault();
            WebPirate.postMessage(target.hasChildNodes() ? "touchhandler_loadurl" : "touchhandler_newtab", { "url": href });
        }

        return;
    }

    this.islongpress = false;
};

window.WebPirate_TouchHandler = new window.WebPirate_TouchHandlerObject();
