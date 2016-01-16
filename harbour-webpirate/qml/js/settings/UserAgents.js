.pragma library

var defaultuseragents = [ {"type": "Mobile",  "value": "Mozilla/5.0 (U; X11; Linux; Maemo; Jolla; Sailfish; like Android 4.3) AppleWebKit/538.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/538.1"},
                          {"type": "Desktop", "value": "Mozilla/5.0 (X11; U; Linux i686; rv:25.0) Gecko/20100101 Firefox/25.0" },
                          {"type": "Android", "value": "Mozilla/5.0 (Linux; Android 4.4; Nexus 4 Build/KRT16H) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36" },
                          {"type": "iPhone",  "value": "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3" } ];

function load(tx)
{
    tx.executeSql("DROP TABLE IF EXISTS UserAgents");
}

function get(idx)
{
    return defaultuseragents[idx];
}
