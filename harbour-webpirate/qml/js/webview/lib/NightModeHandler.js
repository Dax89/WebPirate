window.WebPirate_NightModeHandlerObject = function() {
    this.NIGHTMODE_CLASSNAME = "__wp_nightmode__";
    this.enabled = false;
}

window.WebPirate_NightModeHandlerObject.prototype.createStyle = function() {
    var nmnode = document.getElementById("__wp_css_nightmode__");

    if(nmnode)
        return;

    var css = "html." + this.NIGHTMODE_CLASSNAME + " { -webkit-filter: contrast(68%) brightness(108%) invert(); }\n" +
              "html." + this.NIGHTMODE_CLASSNAME + " iframe { -webkit-filter: invert(); }\n" + // Keep iframes normal
              "html." + this.NIGHTMODE_CLASSNAME + " object { -webkit-filter: invert(); }\n" + // Keep Flash items normal
              "html." + this.NIGHTMODE_CLASSNAME + " embed { -webkit-filter: invert(); }\n"  + // Keep Flash items normal (HTML5)
              "html." + this.NIGHTMODE_CLASSNAME + " video { -webkit-filter: invert(); }\n"  + // Keep HTML5 Videos normal
              "html." + this.NIGHTMODE_CLASSNAME + " img { -webkit-filter: invert(); }" ;      // Keep images normal

    WebPirate.injectCSS(css, "__wp_css_nightmode__");
};

window.WebPirate_NightModeHandlerObject.prototype.switchMode = function(newstate) {
    if(this.enabled === newstate)
        return;

    this.enabled = newstate;
    this.createStyle();

    var html = WebPirate.html;

    if(this.enabled)
        WebPirate.addClass(html, this.NIGHTMODE_CLASSNAME);
    else
        WebPirate.removeClass(html, this.NIGHTMODE_CLASSNAME);

    WebPirate.timeout(function() {
        WebPirate.postMessage("nightmodehandler_changed", { "enabled": newstate });
    }, 600);
}

window.WebPirate_NightModeHandler = new window.WebPirate_NightModeHandlerObject();
