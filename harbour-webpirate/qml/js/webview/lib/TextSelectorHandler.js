window.WebPirate_TextSelectorHandlerObject = function() {
    this.SELECTION_MARKER = "__wp_selection_marker__";
    this.SELECTION_START_MARKER = "__wp_selection_start_marker__";
    this.SELECTION_END_MARKER = "__wp_selection_end_marker__";
    this.SELECTION_WIDTH = 25;
    this.SELECTION_HEIGHT = 40;
    this.SELECTION_PADDING = 20;
    this.selecting = false;
    this.moving = false;
};

window.WebPirate_TextSelectorHandlerObject.prototype.isStartMarker = function(target) {
    return target.className.indexOf(this.SELECTION_START_MARKER) !== -1;
};

window.WebPirate_TextSelectorHandlerObject.prototype.isEndMarker = function(target) {
    return target.className.indexOf(this.SELECTION_END_MARKER) !== -1;
};

window.WebPirate_TextSelectorHandlerObject.prototype.isMarker = function(target) {
    return this.isStartMarker(target) || this.isEndMarker(target);
};

window.WebPirate_TextSelectorHandlerObject.prototype.stopTextSelection = function(touchevent) {
    var target = touchevent.target;

    if(this.isMarker(target))
        return;

    touchevent.preventDefault();
    this.stopSelect();
};

window.WebPirate_TextSelectorHandlerObject.prototype.onTouchStart = function(touchevent) {
    touchevent.preventDefault();
    this.moving = true;
};

window.WebPirate_TextSelectorHandlerObject.prototype.onTouchMove = function(touchevent) {
    if(touchevent.touches.length <= 0)
        return;

    touchevent.preventDefault();

    var target = touchevent.target;
    var touch = touchevent.touches[0];

    var range = document.caretRangeFromPoint(touch.clientX, touch.clientY - (this.SELECTION_HEIGHT + this.SELECTION_PADDING))
    this.updateSelection(target, range);
};

window.WebPirate_TextSelectorHandlerObject.prototype.onTouchEnd = function(touchevent) {
    touchevent.preventDefault();
    this.moving = false;
};

window.WebPirate_TextSelectorHandlerObject.prototype.isReversed = function(oldrange) {
    if(oldrange.collapsed)
        return true;

    return false;
};

window.WebPirate_TextSelectorHandlerObject.prototype.swapMarkers = function() {
    var startmarker = document.querySelector("." + this.SELECTION_START_MARKER);
    var endmarker = document.querySelector("." + this.SELECTION_END_MARKER);

    startmarker.className = this.SELECTION_MARKER + " " + this.SELECTION_END_MARKER;
    endmarker.className = this.SELECTION_MARKER + " " + this.SELECTION_START_MARKER;
};

window.WebPirate_TextSelectorHandlerObject.prototype.updateSelection = function(target, newrange) {
    var selection = window.getSelection();
    var oldrange = selection.getRangeAt(0);
    var displaystart = this.isStartMarker(target)
    var displayend = this.isEndMarker(target)
    var reversed = this.isReversed(oldrange);
    var range = document.createRange();

    if(displaystart) {
        if(reversed) {
            range.setStart(oldrange.endContainer, oldrange.endOffset);
            range.setEnd(newrange.startContainer, newrange.startOffset);
        }
        else {
            range.setStart(newrange.startContainer, newrange.startOffset);
            range.setEnd(oldrange.endContainer, oldrange.endOffset);
        }
    }
    else if(displayend) {
        if(reversed) {
            range.setStart(newrange.startContainer, newrange.startOffset);
            range.setEnd(oldrange.endContainer, oldrange.endOffset);
        }
        else {
            range.setStart(oldrange.startContainer, oldrange.startOffset);
            range.setEnd(newrange.endContainer, newrange.endOffset);
        }
    }
    else
        return;

    selection.removeAllRanges();
    selection.addRange(range);

    this.displayMarkers(selection, displaystart, displayend);

    if(reversed)
        this.swapMarkers();
};

window.WebPirate_TextSelectorHandlerObject.prototype.createMarkerStyle = function() {
    var head = document.getElementsByTagName("HEAD")[0];

    // General Style
    var markerstyle = document.createElement("STYLE");
    markerstyle.id = this.SELECTION_MARKER;

    markerstyle.innerHTML = "." + this.SELECTION_MARKER + " {\n" +
            "background: linear-gradient(" + WebPirate_Theme.secondaryColor + " 0, " + WebPirate_Theme.secondaryHighlightColor + " 18px);\n" +
            "background-color: " + WebPirate_Theme.secondaryHighlightColor + ";\n" +
            "box-shadow: 0 1px 3px rgba(0, 0, 0, 0.7);\n" +
            "content: \"\";\n" +
            "display: block;\n" +
            "height: " + this.SELECTION_HEIGHT + "px;\n" +
            "opacity: 0.95;\n" +
            "position: absolute;\n" +
            "width: " + this.SELECTION_WIDTH + "px;\n" +
            "}";

    head.appendChild(markerstyle);

    // Start Marker Style
    markerstyle = document.createElement("STYLE");
    markerstyle.id = this.SELECTION_START_MARKER;

    markerstyle.innerHTML = "." + this.SELECTION_START_MARKER + "{\n" +
            "margin-left: -25px;\n" +
            "border-radius: 25px 0 0 0;\n" +
            "}";

    head.appendChild(markerstyle);

    // End Marker Style
    markerstyle = document.createElement("STYLE");
    markerstyle.id = this.SELECTION_END_MARKER;

    markerstyle.innerHTML = "." + this.SELECTION_END_MARKER + "{\n" +
            "border-radius: 0 25px 0 0;\n" +
            "}";

    head.appendChild(markerstyle);
};

window.WebPirate_TextSelectorHandlerObject.prototype.createMarker = function(style) {
    var marker = document.createElement("DIV");
    marker.className = this.SELECTION_MARKER + " " + style;
    marker.setAttribute("style", "visibility: hidden; pointer-events: auto; z-index: 1200;");

    marker.addEventListener("touchstart", this.onTouchStart.bind(this), true);
    marker.addEventListener("touchmove", this.onTouchMove.bind(this), true);
    marker.addEventListener("touchend", this.onTouchEnd.bind(this), true);

    document.body.appendChild(marker);
};

window.WebPirate_TextSelectorHandlerObject.prototype.displayMarkers = function(selection, displaystart, displayend) {
    if(selection.rangeCount <= 0) {
        this.hideMarkers();
        return;
    }

    this.selecting = true;

    var bodyrect = document.body.getBoundingClientRect();
    var r = selection.getRangeAt(0);
    var rects = r.getClientRects();
    var firstrect = rects[0], lastrect = rects[rects.length - 1];

    if((displaystart === undefined) || displaystart === true) {
        var startmarker = document.querySelector("." + this.SELECTION_START_MARKER);
        startmarker.style.top = ((firstrect.bottom  - bodyrect.top) + this.SELECTION_PADDING) + "px";
        startmarker.style.left = (firstrect.left - bodyrect.left) + "px";
        startmarker.style.visibility = "visible";
    }

    if((displayend === undefined) || displayend === true) {
        var endmarker = document.querySelector("." + this.SELECTION_END_MARKER);
        endmarker.style.top = ((lastrect.bottom - bodyrect.top) + this.SELECTION_PADDING) + "px";
        endmarker.style.left = (lastrect.right - bodyrect.left) + "px";
        endmarker.style.visibility = "visible";
    }
};

window.WebPirate_TextSelectorHandlerObject.prototype.hideMarkers = function() {
    var startmarker = document.querySelector("." + this.SELECTION_START_MARKER);
    var endmarker = document.querySelector("." + this.SELECTION_END_MARKER);

    startmarker.style.visibility = "hidden";
    endmarker.style.visibility = "hidden";

    var selection = window.getSelection();
    selection.removeAllRanges();

    this.selecting = false;
};

window.WebPirate_TextSelectorHandlerObject.prototype.getText = function(id, cancel) {
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);

    WebPirate.postMessage("textselectorhandler_selectedtext", { "id": id,
                                                                "text": WebPirate_Utils.escape(range.toString()) });

    if(cancel === true)
        this.stopSelect();
}

window.WebPirate_TextSelectorHandlerObject.prototype.wordRange = function(clientx, clienty) {
    var range = document.caretRangeFromPoint(clientx, clienty);
    var selstart = range.startContainer;
    var i = range.startOffset;

    while((i > 0) && !/\s/.test(selstart.textContent[i]))
        i--;

    i++; // Stay in bounds with the selected word

    var word = /\w+/.exec(selstart.textContent.substr(i));

    if(!word || !word[0]) { // Fallback to node selection
        range.selectNodeContents(selstart);
        return range;
    }

    range.setStart(selstart, i);
    range.setEnd(selstart, i + word[0].length);
    return range;
};

window.WebPirate_TextSelectorHandlerObject.prototype.stopSelect = function() {
    document.removeEventListener("touchstart", this.stopTextSelection.bind(this));
    WebPirate.postMessage("textselectorhandler_statechanged", { "enabled": false });

    this.hideMarkers();
}

window.WebPirate_TextSelectorHandlerObject.prototype.select = function(clientx, clienty) {
    if(!document.getElementById(this.SELECTION_MARKER)) {
        this.createMarkerStyle();
        this.createMarker(this.SELECTION_START_MARKER);
        this.createMarker(this.SELECTION_END_MARKER);
    }

    document.addEventListener("touchstart", this.stopTextSelection.bind(this));

    var range = this.wordRange(clientx, clienty);
    var selection = window.getSelection();

    selection.removeAllRanges();
    selection.addRange(range);

    this.displayMarkers(selection);
    WebPirate.postMessage("textselectorhandler_statechanged", { "enabled": true });
};

window.WebPirate_TextSelectorHandler = new window.WebPirate_TextSelectorHandlerObject();
