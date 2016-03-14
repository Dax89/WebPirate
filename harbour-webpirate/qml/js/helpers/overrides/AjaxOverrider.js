var __wp_ajaxoverrider__ = {
    wkxhropen: window.XMLHttpRequest.prototype.open,
    blacklistrgx: null,

    applyBlackList: function(blacklist) {
        __wp_ajaxoverrider__.blacklistrgx = new RegExp(blacklist);
    }
}

window.XMLHttpRequest.prototype.open = function() {
    if(__wp_ajaxoverrider__.blacklistrgx && __wp_ajaxoverrider__.blacklistrgx.test(arguments[1])) {
        console.log("BLOCKED: " + arguments[1]);
        return null;
    }

    return __wp_ajaxoverrider__.wkxhropen.apply(this, [].slice.call(arguments));
}
