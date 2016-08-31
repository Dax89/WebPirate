window.WebPirate_ReaderModeHandlerObject = function() {
    this.enabled = false;
};

window.WebPirate_ReaderModeHandlerObject.prototype.disable = function() {
    this.enabled = false;
    window.location.reload();
};

window.WebPirate_ReaderModeHandlerObject.prototype.enable = function() {
    this.enabled = true;

    var loc = document.location;
    var uri = { "spec": loc.href,
                "host": loc.host,
                "prePath": loc.protocol + "//" + loc.host,
                "scheme": loc.protocol.substr(0, loc.protocol.indexOf(":")),
                "pathBase": loc.protocol + "//" + loc.host + loc.pathname.substr(0, loc.pathname.lastIndexOf("/") + 1) };

    var readability = new window.Readability(uri, document);
    var res = readability.parse();

    document.title = res.title;
    document.body.innerHTML = res.content;
};

window.WebPirate_ReaderModeHandlerObject.prototype.switchMode = function(enabled) {
    if(this.enabled === enabled)
        return;

    if(this.enabled) {
        this.disable();
        return;
    }

    this.enable();
};

window.WebPirate_ReaderModeHandler = new window.WebPirate_ReaderModeHandlerObject();
