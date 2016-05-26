window.WebPirate_AjaxOverriderObject = function() {
    this.wkxhropen = window.XMLHttpRequest.prototype.open;
    this.blacklistrgx = null;

    window.XMLHttpRequest.prototype.open = function() {
        if(WebPirate_AjaxOverriderObject.blacklistrgx && WebPirate_AjaxOverriderObject.blacklistrgx.test(arguments[1])) {
            console.log("BLOCKED: " + arguments[1]);
            return null;
        }

        return this.wkxhropen.apply(this, [].slice.call(arguments));
    }
};

window.WebPirate_AhaxOverriderObject.prototype.applyBlackList = function(blacklist) {
    this.blacklistrgx = new RegExp(blacklist);
};

window.WebPirate_AjaxOverrider = new window.WebPirate_AjaxOverriderObject();
