var timerid;
var islongpress = false;
var currtouch = null;

/*
function getTextNodes(node)
{
    var textnodes = [];

    if(node.nodeType === 3)
        textnodes.push(node);
    else
    {
        var children = node.childNodes;

        for(var i = 0; i < children.length; i++)
            textnodes.push.apply(textnodes, getTextNodes(children[i]));
    }

    return textnodes;
}

function clearSelection()
{
    var sel = window.getSelection();
    sel.removeAllRanges();
    return sel;
}

function selectText(element, start, end)
{
    var range = document.createRange();
    range.selectNodeContents(element);

    var foundstart = false;
    var charcount = 0, endcharcount;
    var textnodes = getTextNodes(element);

    for(var i = 0, tn; (tn = textnodes[i++]); )
    {
        endcharcount = charcount + tn.length;

        if(!foundstart && (start >= charcount) && (start < endcharcount || (start === endcharcount && i < textnodes.length)))
        {
            range.setStart(tn, start - charcount);
            foundstart = true;
        }

        if(foundstart && (end < endcharcount))
        {
            range.setEnd(tn, end - charcount);
            break;
        }

        charcount = endcharcount;
    }

    var sel = clearSelection();
    sel.addRange(range);

    var clientrects = range.getClientRects();

    if(!clientrects.length)
        return;

    var data = new Object;
    data.type = "selectionchanged";
    data.left = clientrects[0].left;
    data.top = clientrects[0].top;
    data.right = clientrects[clientrects.length - 1].right;
    data.bottom = clientrects[clientrects.length - 1].bottom;

    navigator.qt.postMessage(JSON.stringify(data));
}
*/

function checkLongPress(x, y, target)
{
    islongpress = true;
    var rect = target.getBoundingClientRect();

    var data = new Object;
    data.type = "longpress";
    data.x = x;
    data.y = y;
    data.left = rect.left;
    data.top = rect.top;
    data.width = rect.width;
    data.height = rect.height;

    if(target.tagName === "A")
    {
        data.url = target.href;
        data.isimage = false;
    }
    else if(target.parentNode.tagName === 'A')
    {
        data.url = target.parentNode.href;
        data.isimage = false;
    }
    else if(target.tagName === "IMG")
    {
        data.url = target.src;
        data.isimage = true;
    }
    else if(target.textContent)
        data.text = target.innerText;
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

    var data = new Object;
    data.type = "touchstart"
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
    if(islongpress)
    {
        islongpress = false;
        touchevent.preventDefault();
    }

    clearTimeout(timerid);
    currtouch = null;
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
