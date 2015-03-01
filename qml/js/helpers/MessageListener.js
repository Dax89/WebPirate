var __wp_messagedispatcher__  = {
    "forcepixelratio": function() { __wp_forcepixelratio__.adjust(); },
    "polish_document":  function() { __webpirate__.polishDocument(); },
    "enable_nightmode": function() { __wp_nightmode__.switchMode(true); },
    "disable_nightmode": function() { __wp_nightmode__.switchMode(false); },
    "video_get": function() { __wp_videohelper__.getVideo(); },
    "video_getembedded": function() { __wp_videohelper__.getEmbeddedVideos(); }
};

navigator.qt.onmessage = function(message) {
    var messagehandler = __wp_messagedispatcher__[message.data];

    if(messagehandler)
        messagehandler();
}
