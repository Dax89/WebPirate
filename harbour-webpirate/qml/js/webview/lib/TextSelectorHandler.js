window.WebPirate_TextSelectorHandlerObject = function() {
    this.MARKER_SIZE = 30;
    this.MARKER_SIZE_2 = this.MARKER_SIZE / 2;
    this.MARKER_SIZE_4 = this.MARKER_SIZE / 4;
};

window.WebPirate_TextSelectorHandlerObject.prototype.isReversed = function(oldrange) {
    if(oldrange.collapsed)
        return true;

    return false;
};

window.WebPirate_TextSelectorHandlerObject.prototype.updateSelection = function(touchdata) {
    var selection = window.getSelection();
    var oldrange = selection.getRangeAt(0);
    var reversed = this.isReversed(oldrange);
    var newrange = document.caretRangeFromPoint(touchdata.x, touchdata.y);
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

    this.displayHandles(selection, touchdata.start, !touchdata.start);
};

window.WebPirate_TextSelectorHandlerObject.prototype.displayHandles = function(selection, displaystart, displayend) {
    if(selection.rangeCount <= 0) {
        this.cancelSelect();
        return;
    }

    var bodyrect = document.body.getBoundingClientRect();
    var r = selection.getRangeAt(0);
    var rects = r.getClientRects();
    var firstrect = rects[0], lastrect = rects[rects.length - 1];
    var data = { "size": this.MARKER_SIZE };

    if((displaystart === undefined) || displaystart === true)
        data.start = { "x": (firstrect.left - bodyrect.left) - this.MARKER_SIZE_2, "y": (firstrect.bottom  - bodyrect.top) - (firstrect.height / 2) - this.MARKER_SIZE_4 };

    if((displayend === undefined) || displayend === true)
        data.end = { "x": (lastrect.right - bodyrect.left) - this.MARKER_SIZE_4, "y": (lastrect.bottom  - bodyrect.top) - (lastrect.height / 2) - this.MARKER_SIZE_4 };

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
    this.displayHandles(selection);
    WebPirate.postMessage("textselectorhandler_statechanged", { "enabled": true });
};

window.WebPirate_TextSelectorHandler = new window.WebPirate_TextSelectorHandlerObject();
