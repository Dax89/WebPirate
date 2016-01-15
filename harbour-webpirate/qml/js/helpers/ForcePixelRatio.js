/*
 * Glorious hack to fix wrong device Pixel Ratio reported by Webview (I hope Jolla will fix this soon)
 * Issue: https://github.com/Dax89/harbour-webpirate/issues/3
 *
 * Thanks to llelectronics for allowing me to use his trick :)
 */
var __wp_forcepixelratio__ = {

    blacklist: { "www.tagesschau.de": true,
                 "www.dailymotion.com": true },

    adjust: function() {
        if(__wp_forcepixelratio__.blacklist[document.location.hostname]) // Horrible Hack: Do not trigger DevicePixelRatio on these sites
            return;

        var viewport = document.querySelector("meta[name='viewport']");

        if(!viewport)
            return;

        if(screen.width <= 540) /* Jolla devicePixelRatio: 1.5 */
            viewport.content = "width=device-width/1.5, initial-scale=1.5";
        else if(screen.width > 540 && screen.width <= 768) /* Nexus 4 devicePixelRatio: 2.0 */
            viewport.content = "width=device-width/2.0, initial-scale=2.0";
        else if (screen.width > 768) /* Nexus 5 devicePixelRatio: 3.0 */
            viewport.content = "width=device-width/3.0, initial-scale=3.0";
    }
}
