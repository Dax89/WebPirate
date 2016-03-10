.pragma library

var defaultuseragents = [ {"type": "Mobile",     "value": "" },
                          {"type": "Desktop",    "value": "Mozilla/5.0 (X11; Linux) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453 Safari/537.36" },
                          {"type": "Android",    "value": "Mozilla/5.0 (Linux; Android 4.4; Nexus 4 Build/KRT16H) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36" },
                          {"type": "iPhone",     "value": "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3" },
                          {"type": "GoogleBot",  "value": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" } ];

function load(tx)
{
    tx.executeSql("DROP TABLE IF EXISTS UserAgents");
}

function get(idx)
{
    return defaultuseragents[idx];
}

function buildUA(version, wkversion) {
    defaultuseragents[0].value = "Mozilla/5.0 (U; Linux; Maemo; Jolla; Sailfish; like Android 4.3) " +
                                 "AppleWebKit/" + wkversion + " (KHTML, like Gecko) WebPirate/" + version + " Mobile Safari/" + wkversion;
}
