var __wp_messagedispatcher__  = {
    "forcepixelratio": function() { __wp_forcepixelratio__.adjust(); },
    "enable_nightmode": function() { __wp_nightmode__.switchMode(true); },
    "disable_nightmode": function() { __wp_nightmode__.switchMode(false); },
    "polish_document":  function() { __webpirate__.polishDocument(); },
    "youtube_convertvideo": function() { __yt_webpirate__.convertVideo(); }
};

navigator.qt.onmessage = function(message) {
    var messagehandler = __wp_messagedispatcher__[message.data];

    if(messagehandler)
        messagehandler();
}
