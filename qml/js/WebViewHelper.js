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

document.addEventListener("touchstart", onTouchStart, true);
document.addEventListener("touchmove", onTouchMove, true);
document.addEventListener("touchend", onTouchEnd, true);
