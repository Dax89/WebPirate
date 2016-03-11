window.Notification = function(title, options) {
    if(window.Notification.permission !== window.Notification.__WP_PERMISSION_GRANTED__)
        return;

    options = options || { };

    this.body = options.body || "";
    this.icon = options.icon || "";
    this.lang = options.lang || "";
    this.tag = options.tag || "";

    this.close = function() { }
    this.onclick = function() { };
    this.onclose = function() { };

    if(options.icon) { // We want an absolute path
        var link = document.createElement("a");
        link.href = options.icon;
        options.icon = link.protocol + "//" + link.host + link.pathname + link.search + link.hash;
    }

    var data = new Object;
    data.type = "notification_created";
    data.title = title;
    data.options = options;

    navigator.qt.postMessage(JSON.stringify(data));
}

window.Notification.requestPermission = function() {
    if(window.Notification.permission !== window.Notification.__WP_PERMISSION_DEFAULT__)
        return;

    window.webkitNotifications.requestPermission();
}

window.Notification.__WP_PERMISSION_GRANTED__ = "granted";
window.Notification.__WP_PERMISSION_DENIED__ = "denied";
window.Notification.__WP_PERMISSION_DEFAULT__ = "default";
window.Notification.permission = window.Notification.__WP_PERMISSION_DEFAULT__;
