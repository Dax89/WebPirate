window.WebPirate_StyleHandlerObject = function() {
    var style = window.getComputedStyle(document.body);
    WebPirate.postMessage("stylehandler_style", { "backgroundColor": WebPirate_Utils.rgb(style.backgroundColor) });
};

window.WebPirate_StyleHandler = new window.WebPirate_StyleHandlerObject();
