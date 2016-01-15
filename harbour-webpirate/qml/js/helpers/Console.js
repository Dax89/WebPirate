console.log = function(log) {
    var data = new Object;
    data.type = "console_log";
    data.log = log;

    navigator.qt.postMessage(JSON.stringify(data));
}

console.error = function(error) {
    var data = new Object;
    data.type = "console_error";
    data.log = log;

    navigator.qt.postMessage(JSON.stringify(data));
}
