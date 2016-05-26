window.WebPirate_UtilsObject =  function() {

};

window.WebPirate_UtilsObject.prototype.dump = function(obj) {
    for(var prop in obj) {
        var val = "";

        if(typeof obj[prop] === "function")
            val = obj[prop].constructor.name;
        else
            val = obj[prop].toString();

        console.log(prop + ": '" + val + "'");
    }
}

window.WebPirate_UtilsObject.prototype.escape = function(s) {
    return s.replace(/&#39;/g, "'");
};

window.WebPirate_UtilsObject.prototype.unescape = function(s) {
    return s.replace(/&#39;/g, "'");
};

window.WebPirate_UtilsObject.prototype.rgb2hex = function (rgb) {
    rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);

    return (rgb && rgb.length === 4) ? "#" + ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
                                             ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
                                             ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
};

window.WebPirate_UtilsObject.prototype.hexToColor = function(hex) {
    var shorthandrgx = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;

    hex = hex.replace(shorthandrgx, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? { r: parseInt(result[1], 16),
                      g: parseInt(result[2], 16),
                      b: parseInt(result[3], 16) } : null;
};

window.WebPirate_UtilsObject.prototype.rgb = function(s) {
    if(s.slice(0, 1) === "#")
        return this.hexToColor(s);

    var hex = this.rgb2hex(s);

    if(!hex.length)
        return null;

    return this.hexToColor(hex);
};

window.WebPirate_Utils = new window.WebPirate_UtilsObject();
