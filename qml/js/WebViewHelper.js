var timerid;
var islongpress = false;
var currtouch = null;

function checkLongPress(x, y, target)
{
    islongpress = true;

    var data = new Object;
    data.type = "longpress";
    data.x = x;
    data.y = y;

    if(target.tagName === "A")
        data.url = target.href;
    else
        return;

    navigator.qt.postMessage(JSON.stringify(data));
}

function onTouchStart(touchevent)
{
    if(touchevent.touches.length === 1)
    {
        currtouch = touchevent.touches[0];
        timerid = setTimeout(checkLongPress, 800, currtouch.clientX, currtouch.clientY, touchevent.target);
    }

    var data = new Object
    data.type = "touchstart";

    navigator.qt.postMessage(JSON.stringify(data));
}

function onTouchEnd(touchevent)
{
    if(islongpress)
    {
        islongpress = false;
        touchevent.preventDefault();
    }

    currtouch = null;
    clearTimeout(timerid);
}

function onTouchMove(touchevent)
{
    islongpress = false;
    currtouch = null;
    clearTimeout(timerid);
}

function onSubmit(event)
{
    var inputelements = event.target.getElementsByTagName("input");

    var logindata = new Object
    logindata.type = "submit";

    for(var i = 0; i < inputelements.length; i++)
    {
        var input = inputelements[i];

        if((input.id === null && input.name === null) || input.value === null || input.value.length === 0)
            continue;

        if(input.type === "text" || input.type === "email")
        {
            logindata.loginattribute = input.id ? "id" : "name";
            logindata.loginid = input.id ? input.id : input.name;
            logindata.login = input.value;

            if(logindata.password)
                break;
        }
        else if(input.type === "password")
        {
            logindata.passwordattribute = input.id ? "id" : "name";
            logindata.passwordid = input.id ? input.id : input.name;
            logindata.password = input.value;

            if(logindata.login)
                break;
        }
    }

    if(logindata.loginid && logindata.login && logindata.passwordid && logindata.password)
        navigator.qt.postMessage(JSON.stringify(logindata));
}

document.addEventListener("touchstart", onTouchStart, true);
document.addEventListener("touchmove", onTouchMove, true);
document.addEventListener("touchend", onTouchEnd, true);
document.addEventListener("submit", onSubmit, true);
