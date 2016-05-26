/*
 * Glorious hack to fix wrong device Pixel Ratio reported by Webview (I hope Jolla will fix this soon)
 * Thanks to llelectronics for allowing me to use his trick :)
 */

window.WebPirateObject_PixelRatioHandlerObject = function() {
    this.BLACKLIST = "tagesschau.de|dailymotion.com";
    this.update();
};

window.WebPirateObject_PixelRatioHandlerObject.prototype.update = function() {
    if(WebPirate.isDomain(this.BLACKLIST))
        return;

    WebPirate.query("meta[name='viewport']", function(viewport) {
        if(window.screen.width <= 540) // Jolla devicePixelRatio: 1.5
            viewport.content = "width=device-width/1.5, initial-scale=1.5";
        else if(window.screen.width > 540 && screen.width <= 768) // Nexus 4 devicePixelRatio: 2.0
            viewport.content = "width=device-width/2.0, initial-scale=2.0";
        else if (window.screen.width > 768) // Nexus 5 devicePixelRatio: 3.0
            viewport.content = "width=device-width/3.0, initial-scale=3.0";
    });
};

window.WebPirate_PixelRatioHandler = new WebPirateObject_PixelRatioHandlerObject();
