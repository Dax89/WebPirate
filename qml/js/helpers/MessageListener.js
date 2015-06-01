var __wp_messagedispatcher__  = {
    "forcepixelratio": function() { __wp_forcepixelratio__.adjust(); },
    "polish_document":  function() { __webpirate__.polishDocument(); },
    "nightmode_enable": function() { __wp_nightmode__.switchMode(true); },
    "nightmode_disable": function() { __wp_nightmode__.switchMode(false); },
    "notification_granted": function() { window.Notification.permission = window.Notification.__WP_PERMISSION_GRANTED__; },
    "notification_denied": function() { window.Notification.permission = window.Notification.__WP_PERMISSION_DENIED__; },
    "notification_default": function() { window.Notification.permission = window.Notification.__WP_PERMISSION_DEFAULT__; },
    "video_get": function() { __wp_videohelper__.getVideo(); }
};

navigator.qt.onmessage = function(message) {
    var messagehandler = __wp_messagedispatcher__[message.data];

    if(messagehandler)
        messagehandler();
}
