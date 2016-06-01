window.WebPirate_TextSelectorHandlerObject = function() {
    this.scale = 1.0; // Placeholder Value
};

window.WebPirate_TextSelectorHandlerObject.prototype.setHandleSize = function(size) {
    this.MARKER_SIZE = size;
    this.MARKER_SIZE_HALF = this.MARKER_SIZE / 2;
    this.MARKER_SIZE_DOUBLE_HALF = this.MARKER_SIZE / 4;
    this.MARKER_SIZE_DOUBLE = this.MARKER_SIZE * 2;
};

window.WebPirate_TextSelectorHandlerObject.prototype.isReversed = function(newrange, oldrange, displaystart) {
    var newrect = newrange.getBoundingClientRect();
    var oldrect = oldrange.getBoundingClientRect();

    if(displaystart === true)
        return (newrange.startOffset >= oldrange.endOffset) && (newrect.top >= oldrect.bottom);

    return (newrange.startOffset <= oldrange.startOffset) && (newrect.top <= oldrect.top);
};

window.WebPirate_TextSelectorHandlerObject.prototype.updateSelection = function(touchdata) {
    var selection = window.getSelection();
    var oldrange = selection.getRangeAt(0);
    var newrange = document.caretRangeFromPoint(touchdata.x, touchdata.y - this.MARKER_SIZE);
    var reversed = this.isReversed(newrange, oldrange, touchdata.start);
    var range = document.createRange();

    if(touchdata.start) {
        if(reversed) {
            range.setStart(oldrange.endContainer, oldrange.endOffset);
            range.setEnd(newrange.startContainer, newrange.startOffset);
        }
        else {
            range.setStart(newrange.startContainer, newrange.startOffset);
            range.setEnd(oldrange.endContainer, oldrange.endOffset);
        }
    }
    else {
        if(reversed) {
            range.setStart(newrange.startContainer, newrange.startOffset);
            range.setEnd(oldrange.endContainer, oldrange.endOffset);
        }
        else {
            range.setStart(oldrange.startContainer, oldrange.startOffset);
            range.setEnd(newrange.endContainer, newrange.endOffset);
        }
    }

    selection.removeAllRanges();
    selection.addRange(range);

    this.displayHandles(range, reversed);
};

window.WebPirate_TextSelectorHandlerObject.prototype.displayHandles = function(range, reversed) {
    var bodyrect = document.body.getBoundingClientRect();
    var rects = range.getClientRects();
    var firstrect = rects[0], lastrect = rects[rects.length - 1];
    var data = { "reversed": reversed || false };

    data.start = { "x": (firstrect.left - bodyrect.left) - (this.MARKER_SIZE / this.scale), "y": (firstrect.bottom  - bodyrect.top) };
    data.end = { "x": (lastrect.right - bodyrect.left), "y": (lastrect.bottom  - bodyrect.top) };
    WebPirate.postMessage("textselectorhandler_displayhandles", data);
};

window.WebPirate_TextSelectorHandlerObject.prototype.cancelSelect = function() {
    var selection = window.getSelection();
    selection.removeAllRanges();
};

window.WebPirate_TextSelectorHandlerObject.prototype.getText = function(id, cancel) {
    var selection = window.getSelection();
    var range = selection.getRangeAt(0);

    WebPirate.postMessage("textselectorhandler_selectedtext", { "id": id,
                                                                "text": WebPirate_Utils.escape(range.toString()) });

    if(cancel === true)
        this.cancelSelect();
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

window.WebPirate_TextSelectorHandlerObject.prototype.select = function(clientx, clienty) {
    var range = this.wordRange(clientx, clienty);
    var selection = window.getSelection();

    selection.removeAllRanges();
    selection.addRange(range);
    this.displayHandles(range);
    WebPirate.postMessage("textselectorhandler_statechanged", { "enabled": true });
};

window.WebPirate_TextSelectorHandler = new window.WebPirate_TextSelectorHandlerObject();
