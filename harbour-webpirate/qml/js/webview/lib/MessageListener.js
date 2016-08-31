window.WebPirate_MessageListenerObject = function() {
    navigator.qt.onmessage = this.onMessage.bind(this);
};

window.WebPirate_MessageListenerObject.prototype.onMessage = function(message) {
    var obj = JSON.parse(message.data);
    var data = obj.data;

    if(obj.type === "textfieldhandler_override")
        WebPirate_TextFieldHandler.overrideenabled = true;
    else if(obj.type === "textfieldhandler_sendedit")
        WebPirate_TextFieldHandler.sendEdit(data.id, data.text, data.selectionStart, data.selectionEnd);
    else if(obj.type === "textfieldhandler_canceledit")
        WebPirate_TextFieldHandler.cancelEdit(data.id);
    else if(obj.type === "textselectorhandler_cancel")
        WebPirate_TextSelectorHandler.cancelSelect();
    else if(obj.type === "textselectorhandler_gettext")
        WebPirate_TextSelectorHandler.getText(data.id, data.cancel);
    else if(obj.type === "textselectorhandler_updateselection")
        WebPirate_TextSelectorHandler.updateSelection(data.touchdata);
    else if(obj.type === "textselectorhandler_setscale")
        WebPirate_TextSelectorHandler.scale = data.scale;
    else if(obj.type === "textselectorhandler_sethandlesize")
        WebPirate_TextSelectorHandler.setHandleSize(data.size);
    else if(obj.type === "nightmodehandler_enable")
        WebPirate_NightModeHandler.switchMode(true);
    else if(obj.type === "nightmodehandler_disable")
        WebPirate_NightModeHandler.switchMode(false);
    else if(obj.type === "readermodehandler_enable")
        WebPirate_ReaderModeHandler.switchMode(true);
    else if(obj.type === "readermodehandler_disable")
        WebPirate_ReaderModeHandler.switchMode(false);
    else if(obj.type === "notificationhandler_granted")
        window.Notification.permission = window.Notification.__WP_PERMISSION_GRANTED__;
    else if(obj.type === "notificationhandler_denied")
        window.Notification.permission = window.Notification.__WP_PERMISSION_DENIED__;
    else if(obj.type === "notificationhandler_default")
        window.Notification.permission = window.Notification.__WP_PERMISSION_DEFAULT__;
    else if(obj.type === "ajaxoverrider_applyblacklist")
        WebPirate_AjaxOverrider.applyBlacklist(data.blacklist);
    else if(obj.type === "theme_set")
        WebPirate_Theme.set(data.theme);
    else if(obj.type === "theme_applyambience")
        WebPirate_Theme.applyAmbience();
};

window.WebPirate_MessageListener = new window.WebPirate_MessageListenerObject();
