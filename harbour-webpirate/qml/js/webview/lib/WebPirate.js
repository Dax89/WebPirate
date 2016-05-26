window.WebPirateObject = function() {
    this.VERSION = "1.0"
    this.domain = document.location.hostname;
    this.html = document.getElementsByTagName("html")[0];
};

window.WebPirateObject.prototype.injectCSS = function(css, id) {
    var style = document.createElement("STYLE");

    if(typeof id === "string")
        style.id = id;

    style.type = "text/css";
    style.appendChild(document.createTextNode(css));
    document.head.appendChild(style);
};

window.WebPirateObject.prototype.inherit = function(From, obj) {
    obj = obj || function() { };
    obj.prototype = new From();
    return obj;
}

window.WebPirateObject.prototype.capture = function(rgx, s, callback, idx) {
    if(typeof callback !== "function") {
        console.error("Invalid callback");
        return null;
    }

    var cap = rgx.exec(s);

    if(!cap) {
        console.error("Invalid capture");
        return null;
    }

    if(!cap[idx || 1]) {
        console.error("Invalid capture at index " + (idx || 1));
        return null;
    }

    callback(cap[idx || 1], cap);
};

window.WebPirateObject.prototype.postMessage = function(type, data) {
    navigator.qt.postMessage(JSON.stringify({ "type": type, "data": data }));
};

window.WebPirateObject.prototype.hasClass = function(element, classname) {
    return element.className.indexOf(classname) !== -1;
}

window.WebPirateObject.prototype.addClass = function(element, classname) {
    element.className += " " + classname;
}

window.WebPirateObject.prototype.removeClass = function(element, classname) {
    element.className = element.className.replace(classname, "");
}

window.WebPirateObject.prototype.isDomain = function(domain) {
    var domainrgx = new RegExp(domain);
    return domainrgx.test(this.domain);
}

window.WebPirateObject.prototype.timeout = function(callback, milliseconds, thethis) {
    return setTimeout(callback.bind(thethis || this), milliseconds);
}

window.WebPirateObject.prototype.interval = function(callback, milliseconds, thethis) {
    return setInterval(callback.bind(thethis || this), milliseconds);
}

window.WebPirateObject.prototype.capture = function(rgx, s, callback, idx) {
    if(typeof callback !== "function") {
        console.error("Invalid callback");
        return null;
    }

    var cap = rgx.exec(s);

    if(!cap) {
        console.error("Invalid capture");
        return null;
    }

    if(!cap[idx || 1]) {
        console.error("Invalid capture at index " + (idx || 1));
        return null;
    }

    callback(cap[idx || 1], cap);
};

window.WebPirateObject.prototype.removeElement = function(selector) {
  this.query(selector, function(element) { element.remove(); });
};

window.WebPirateObject.prototype.query = function(selector, callback, errorcallback) {
    var element = document.querySelector(selector);

    if(!element || (typeof callback !== "function")) {

        if(!element && (typeof errorcallback === "function"))
            errorcallback();

        return;
    }

    callback(element);
};

window.WebPirateObject.prototype.ajax = function(type, url, callback, data, header, responsetype) {
    if(typeof callback !== "function") {
        console.error("Invalid callback");
        return;
    }

    var req = new XMLHttpRequest();

    if(header !== null) {
        for(var i = 0; i < header.length; i++)
            req.setRequestHeader(header[i].header, header[i].value);
    }

    if(typeof data === "string")
        data = data.replace("|", "&");

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            if(responsetype === "json")
                callback(JSON.parse(req.responseText), req.responseText);
            else
                callback(req.responseText);
        }
    };

    if(type === "GET") {
        if(typeof data === "string")
            req.open(type, url + "?" + data);
        else
            req.open(type, url);

        req.send();
    }
    else if(type === "POST") {
        req.open(type, url);
        req.send(data);
    }
    else
        console.error("AJAX request's type should be POST or GET not '" + type + "'");
};

window.WebPirateObject.prototype.get = function(url, callback, data, header, responsetype) {
    this.ajax("GET", url, callback, data, header, responsetype);
};

window.WebPirateObject.prototype.post = function(url, callback, data, header, responsetype) {
    this.ajax("POST", url, callback, data, header, responsetype);
};

window.WebPirate = new window.WebPirateObject();
