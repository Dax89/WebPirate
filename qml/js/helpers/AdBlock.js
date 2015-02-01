/*
var __wp_ajax__ = {
    listener: new Object(),

    listenerOpen: function(method, url, async, user, pass) {
        console.log("Sniffed: " + method + ": " + url);
        __wp_ajax__.listener.originalOpen.call(this, method, url, async, user, pass);
    },

    listenerSend: function(data) {
        __wp_ajax__.listener.originalSend.call(this, data);
    },

    inject: function() {
        __wp_ajax__.listener.originalOpen = XMLHttpRequest.prototype.open;
        __wp_ajax__.listener.originalSend = XMLHttpRequest.prototype.send;

        XMLHttpRequest.prototype.open = __wp_ajax__.listenerOpen;
        XMLHttpRequest.prototype.send = __wp_ajax__.listenerSend;
    }
};

__wp_ajax__.inject();
*/

var __wp_adblock__ = {
    //blockedCount: 0,

    blockedSelectors: [ "script + ins",
                        "div[id^='dotnAd']",
                        "div[id^='meetic']",
                        "div[id^='meetic']",
                        "div[id^='eadv']",
                        "div[class*='adv']",
                        "div[class$='fblikebox']",
                        "div#cboxOverlay + div#colorbox, div#cboxOverlay",

                        "iframe[id^='google_ads_']",
                        "iframe[id^='ad_']",
                        "iframe[src*='ad.']",

                        "a[href*='ad.']",

                        ".adsbygoogle"],

    blockElement: function(element) {
        if(!element)
            return;

        element.style.cssText = "display:none !important";
        //__wp_adblock__.blockedCount++;
    },

    blockSelectors: function() {
        var selectors = __wp_adblock__.blockedSelectors;

        for(var i = 0; i < selectors.length; i++) {
            var elements = document.querySelectorAll(selectors[i]);

            for(var j = 0; j < elements.length; j++)
                __wp_adblock__.blockElement(elements[j]);
        }
    },

    blockAds: function() {
        //__wp_adblock__.blockedCount = 0;
        //var start = Date.now();

        __wp_adblock__.blockSelectors();
        //console.log("JsAdBlock, Blocked " + __wp_adblock__.blockedCount + " ads in " + (Date.now() - start) + " ms");
    }
};
