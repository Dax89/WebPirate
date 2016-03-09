var __wp_utils__ = {
    escape: function(s) {
        return s.replace(/&#39;/g, "'");
    },

    unescape: function(s) {
        return s.replace(/&#39;/g, "'");
    },

    rgb2hex: function (rgb) {
        rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);

        return (rgb && rgb.length === 4) ? "#" +
               ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
               ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
               ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
    },

    hexToColor: function(hex) {
        // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
        var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;

        hex = hex.replace(shorthandRegex, function(m, r, g, b) {
            return r + r + g + g + b + b;
        });

        var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? { r: parseInt(result[1], 16), g: parseInt(result[2], 16), b: parseInt(result[3], 16) } : null;
    },

    rgb: function(s) {
        if(s.slice(0, 1) === "#") // #rrggbb type
            return __wp_utils__.hexToColor(s);

        // Should be rgb(r,g,b) type
        var hex = __wp_utils__.rgb2hex(s);

        if(!hex.length)
            return null;

        return __wp_utils__.hexToColor(hex);
    },

    getDomain: function() {
        var domain = document.location.hostname;
        var cap = /[www|m]*[0-9]*[\.]*([^$/:]+)/.exec(domain);

        if(cap && cap[1])
            return cap[1];

        return domain;
    },
}
