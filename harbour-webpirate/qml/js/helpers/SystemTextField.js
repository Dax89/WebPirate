var __wp_systemtextfield__ = {
    overrideEnabled: false,
    elementMap: null,

    fakeKeyUpEvent: function(target) {
        var evt = document.createEvent("KeyboardEvent");
        evt.initKeyboardEvent('keyup', true, false, window, '', 0, false, false, false, false, false);
        target.dispatchEvent(evt);
    },

    checkTextField: function(clickevent) {
        if(!__wp_systemtextfield__.overrideEnabled)
            return;

        var target = clickevent.target;

        if(!target || (target.tagName !== "TEXTAREA"))
            return;

        if(target.readOnly) /* Ignore ReadOnly TextAreas */
            return;

        clickevent.preventDefault();

        if(!__wp_systemtextfield__.elementMap)
            __wp_systemtextfield__.elementMap = new Object;

        var id = Date.now();
        __wp_systemtextfield__.elementMap[id] = target;

        var data = new Object;
        data.type = "textfield_selected";
        data.id = id.toString();
        data.maxlength = target.maxLength;
        data.selectionstart = target.selectionStart;
        data.selectionend = target.selectionEnd;
        data.text = __wp_utils__.escape(target.value);

        navigator.qt.postMessage(JSON.stringify(data));
    },

    sendEdit: function(id, text, startselection, endselection) {
        if(!__wp_systemtextfield__.elementMap[id])
            return;

        var target = __wp_systemtextfield__.elementMap[id];
        target.value = __wp_utils__.unescape(text);
        __wp_systemtextfield__.fakeKeyUpEvent(target); // Facebook needs this

        if(startselection !== endselection) {
            if(startselection)
                target.startSelection = startselection;

            if(endselection)
                target.endSelection = endselection;
        }

        __wp_systemtextfield__.cancelEdit(id);
    },

    cancelEdit: function(id) {
        var target = __wp_systemtextfield__.elementMap[id];

        if(!target)
            return;

        target.blur();
        delete __wp_systemtextfield__.elementMap[id];
    }
}

document.addEventListener("click",  __wp_systemtextfield__.checkTextField, false); // Process click on 'bubble'
