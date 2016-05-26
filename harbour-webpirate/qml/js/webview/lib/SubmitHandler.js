window.WebPirate_SubmitHandlerObject = function() {
    document.addEventListener("submit", this.onSubmit.bind(this), true);
};

window.WebPirate_SubmitHandlerObject.prototype.onSubmit = function(submitevent) {
    var target = submitevent.target;
    var elements = target.elements;
    var data = { };

    for(var i = 0; elements.length; i++) {
        var element = elements[i];

        if(element.tagName !== "INPUT")
            continue;

        if((element.type === "text") || (element.type === "email")) {
            data.loginAttribute = (element.id.length > 0) ? "id" : "name";
            data.loginId = (element.id.length > 0) ? element.id : element.name;
            data.login = element.value;

            if(typeof data.password === "string")
                break;
        }
        else if(element.type === "password") {
            data.passwordAttribute = (element.id.length > 0) ? "id" : "name";
            data.passwordId = (element.id.length > 0) ? element.id : element.name;
            data.password = element.value;

            if(typeof data.login === "string")
                break;
        }
    }

    if((typeof data.loginId !== "string") || (typeof data.login !== "string") || (typeof data.passwordId !== "string") || (typeof data.password !== "string"))
        return;

    WebPirate.postMessage("submithandler_submit", data);
};

window.WebPirate_SubmitHandler = new window.WebPirate_SubmitHandlerObject();
