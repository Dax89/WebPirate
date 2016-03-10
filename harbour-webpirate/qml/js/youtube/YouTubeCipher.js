.pragma library

function grabPlayerJavascript(ytplayer, mediagrabber, urldecoder)
{
    //var playerid = /html5player-([^/]+)\/html5player.js/.exec(ytplayer.assets.js);
    var req = new XMLHttpRequest();

    mediagrabber.grabStatus = qsTr("Downloading Player's Cipher");

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var funcname = /a.set\("signature",([a-zA-Z0-9\$]+)\([a-z]\)\);/i.exec(req.responseText);

            if(!funcname || !funcname[1]) {
                mediagrabber.grabFailed = true;
                mediagrabber.grabbing = false;
                mediagrabber.grabStatus = qsTr("Cannot find decoding function, report to developer");
                return;
            }

            var funcbodyrgx = new RegExp("function " + funcname[1] + "\\(a\\){([^]*?)}");
            var funcbody = funcbodyrgx.exec(req.responseText);

            if(!funcbody || !funcbody[1]) { // Try with object assignment
                funcbodyrgx = new RegExp(funcname[1] + "=function\\(a\\){([^]*?)}");
                funcbody = funcbodyrgx.exec(req.responseText);
            }

            if(!funcbody || !funcbody[1]) {
                mediagrabber.grabFailed = true;
                mediagrabber.grabbing = false;
                mediagrabber.grabStatus = qsTr("Cannot find decoding function") + " (" + funcname[1] + "), report to developer";
                return;
            }

            var decodeobjname = /([a-zA-Z0-9\$]{2,})\.[a-zA-Z0-9\$]+\(/.exec(funcbody[1]);

            if(!decodeobjname || !decodeobjname[1]) {
                mediagrabber.grabFailed = true;
                mediagrabber.grabbing = false;
                mediagrabber.grabStatus = qsTr("Cannot find decoding object, report to developer");
                return;
            }

            /* Escape $ character, if needed (Javascript allows $myvariable identifiers) */
            var decodeobjrgx = new RegExp(((decodeobjname[1][0] === "$") ? "var \\" : "var ") + decodeobjname[1] + "={([^]*?)};");
            var decodeobj = decodeobjrgx.exec(req.responseText);

            if(!decodeobj || !decodeobj[1]) {
                mediagrabber.grabFailed = true;
                mediagrabber.grabbing = false;
                mediagrabber.grabStatus = qsTr("Cannot find decoding object") + " (" + decodeobjname[1] + "), report to developer";
                return;
            }

            var decodeobjstring = "var " + decodeobjname[1] + " = {" + decodeobj[1] + "};";
            var decodefunc = new Function("a", decodeobjstring + funcbody[1]);
            urldecoder(ytplayer.args.url_encoded_fmt_stream_map, mediagrabber, decodefunc);
        }
    }

    var playerurl = ytplayer.assets.js;

    if(playerurl.indexOf("//") === 0) /* Adjust URL, if needed */
        playerurl = "https:" + ytplayer.assets.js;

    req.open("GET", playerurl);
    req.send();
}

function decodeCipheredVideo(videoid, mediagrabber, urldecoder)
{
    mediagrabber.clearVideos(); /* Delete Ciphered URLs, if any */
    mediagrabber.grabbing = true; /* Force Grabbing State */
    mediagrabber.grabStatus = qsTr("Ciphered Video: Downloading WebPage");

    var req = new XMLHttpRequest();

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var cap = /ytplayer.config = {(.*?)};/.exec(req.responseText);

            if(!cap || !cap[1]) {
                mediagrabber.grabFailed = true;
                mediagrabber.grabbing = false;
                mediagrabber.grabStatus = qsTr("Cannot download Video Configuration");
                return;
            }

            grabPlayerJavascript(JSON.parse("{" + cap[1] + "}"), mediagrabber, urldecoder);
        }
    }

    req.open("GET", "https://www.youtube.com/watch?v=" + videoid + "&gl=US&persist_gl=1&hl=en&persist_hl=1");
    req.send();
}
