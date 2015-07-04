var __wp_systemtextfield__ = {
    overrideEnabled: false,
    elementMap: null,

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
        data.text = __wp_grabberbuilder__.escape(target.value); /* Use Grabber Builder's escape function */

        navigator.qt.postMessage(JSON.stringify(data));
    },

    sendEdit: function(id, text, startselection, endselection) {
        if(!__wp_systemtextfield__.elementMap[id])
            return;

        var target = __wp_systemtextfield__.elementMap[id];
        target.value = __wp_grabberbuilder__.unescape(text);

        if(startselection !== endselection) {
            if(startselection)
                target.startSelection = startselection;

            if(endselection)
                target.endSelection = endselection;
        }

        __wp_systemtextfield__.cancelEdit(id);
    },

    cancelEdit: function(id) {
        if(!__wp_systemtextfield__.elementMap[id])
            return;

        delete __wp_systemtextfield__.elementMap[id];
    }
}

document.addEventListener("click",  __wp_systemtextfield__.checkTextField, false); // Process click on 'bubble'
