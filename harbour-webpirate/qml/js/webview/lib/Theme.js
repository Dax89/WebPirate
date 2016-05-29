window.WebPirate_ThemeObject = function() {

};

window.WebPirate_ThemeObject.prototype.set = function(theme) {
    for(var prop in theme)
        this[prop] = theme[prop];
};

window.WebPirate_ThemeObject.prototype.applyAmbience = function() {
    var css = "* { background-color: " + this.highlightDimmerColor + " !important;\n" +
                  "color: " + this.primaryColor + " !important;\n }\n\n";

    css += "select { color: " + this.highlightDimmerColor + " !important; }\n";
    css += "a { color: " + this.highlightColor + " !important; }";

    console.log(css);
    WebPirate.injectCSS(css, "__wp_theme_ambience__");

    WebPirate.timeout(function() {
        WebPirate.postMessage("theme_ambiencechanged", { "enabled": true });
    }, 600);
}

window.WebPirate_Theme = new window.WebPirate_ThemeObject();
