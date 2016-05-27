window.WebPirate_ThemeObject = function() {

};

window.WebPirate_ThemeObject.prototype.set = function(theme) {
    for(var prop in theme)
        this[prop] = theme[prop];
};

window.WebPirate_Theme = new window.WebPirate_ThemeObject();
