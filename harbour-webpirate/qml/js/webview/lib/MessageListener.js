window.WebPirate_MessageListenerObject = function() {
    this.dispatchers = { "textfieldhandler_override"   : function() { WebPirate_TextFieldHandler.overrideenabled = true; },
                         "nightmodehandler_enable"     : function() { WebPirate_NightModeHandler.switchMode(true); },
                         "nightmodehandler_disable"    : function() { WebPirate_NightModeHandler.switchMode(false); },
                         "notificationhandler_granted" : function() { window.Notification.permission = window.Notification.__WP_PERMISSION_GRANTED__; },
                         "notificationhandler_denied"  : function() { window.Notification.permission = window.Notification.__WP_PERMISSION_DENIED__; },
                         "notificationhandler_default" : function() { window.Notification.permission = window.Notification.__WP_PERMISSION_DEFAULT__; } };

    navigator.qt.onmessage = this.onMessage.bind(this);
};

window.WebPirate_MessageListenerObject.prototype.onMessage = function(message) {
    var obj = JSON.parse(message.data);
    var handler = this.dispatchers[obj.type];

    if(typeof handler === "function") {
        handler();
        return;
    }

    try {
        var data = obj.data;

        if(obj.type === "textfieldhandler_sendedit")
            WebPirate_TextFieldHandler.sendEdit(data.id, data.text, data.selectionStart, data.selectionEnd);
        else if(obj.type === "textfieldhandler_canceledit")
            WebPirate_TextFieldHandler.cancelEdit(data.id);
        else if(obj.type === "ajaxoverrider_applyblacklist")
            WebPirate_AjaxOverrider.applyBlacklist(data.blacklist);
        else if(obj.type === "theme_set")
            WebPirate_Theme.set(data.theme);
    }
    catch(e) { // Catch SyntaxError
        return;
    }
};

window.WebPirate_MessageListener = new window.WebPirate_MessageListenerObject();
