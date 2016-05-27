window.WebPirate_TextFieldHandlerObject = function() {
    this.overrideenabled = false;
    this.elementmap = { };

    document.addEventListener("keydown", this.onKeyDown.bind(this));
    document.addEventListener("click", this.checkTextField.bind(this), false);
};

window.WebPirate_TextFieldHandlerObject.prototype.onKeyDown = function(keydownevent) {
    var target = keydownevent.target;

    if((keydownevent.keyCode !== 13) || (target.tagName !== "TEXTAREA")) // Return key
        return;

    keydownevent.preventDefault();
    var idx = Math.max(target.selectionStart, target.selectionEnd);

    if(!idx)
        target.value = "\n" + target.value;
    else if(idx === (target.textLength - 1))
        target.value = target.value + "\n";
    else
        target.value = target.value.substr(0, idx) + "\n" + target.value.substr(idx);

    target.setSelectionRange(idx + 1, idx + 1);
};

window.WebPirate_TextFieldHandlerObject.prototype.fakeKeyUpEvent = function(target) {
    var event = document.createEvent("KeyboardEvent");
    event.initKeyboardEvent('keyup', true, false, window, '', 0, false, false, false, false, false);
    target.dispatchEvent(event);
};

window.WebPirate_TextFieldHandlerObject.prototype.checkTextField = function(clickevent) {
    var target = clickevent.target;

    if((target.tagName !== "TEXTAREA") || target.readOnly || !this.overrideenabled)
        return;

    clickevent.preventDefault();

    var id = Date.now();
    this.elementmap[id] = target;

    WebPirate.postMessage("textfieldhandler_selected", { "id": id.toString(),
                                                         "maxLength": target.maxLength,
                                                         "selectionStart": target.selectionStart,
                                                         "selectionEnd": target.selectionEnd,
                                                         "text": WebPirate_Utils.escape(target.value) });
};

window.WebPirate_TextFieldHandlerObject.prototype.sendEdit = function(id, text, startselection, endselection) {
    if(!this.elementmap[id])
        return;

    var target = this.elementmap[id];
    target.value = WebPirate_Utils.unescape(text);
    this.fakeKeyUpEvent(target); // Facebook needs this

    if(startselection !== endselection) {
        if(typeof startselection === "number")
            target.startSelection = startselection;

        if(typeof endselection === "number")
            target.endSelection = endselection;
    }
};

window.WebPirate_TextFieldHandlerObject.prototype.cancelEdit = function(id) {
    var target = this.elementmap[id];

    target.blur();
    delete this.elementmap[id];
};

window.WebPirate_TextFieldHandler = new window.WebPirate_TextFieldHandlerObject();
