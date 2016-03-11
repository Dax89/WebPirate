var __wp_tohkbd__ = {
    onKeyDown: function(event) {
        var target = event.target;

        if(!target || (target.tagName !== "TEXTAREA"))
            return;

        if(event.keyCode === 13) { // Return Key
            event.preventDefault();

            var idx = Math.max(target.selectionStart, target.selectionEnd);
            console.log(idx + " " + (target.textLength - 1));

            if(!idx)
                target.value = "\n" + target.value;
            else if(idx === (target.textLength - 1))
                target.value = target.value + "\n";
            else
                target.value = target.value.substr(0, idx) + "\n" + target.value.substr(idx);

            target.setSelectionRange(idx + 1, idx + 1);
        }
    }
}

document.addEventListener("keydown", __wp_tohkbd__.onKeyDown);
