var __wp_vimeohelper__ = {
    playbutton: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAAEsBAMAAACLU5NGAAAAIVBMVEUAAAAjHyAjHyA4NTaopqcjHyBxb3AjHyAjHyD////U09SUDTPUAAAACXRSTlMA1ZnT92boHg06O1hfAAACJUlEQVR42u3cMUscQRiA4UAIpp0cIZDKS5O006YLUyWVSRDrKe3Owl78DdN80yoD/ksVsfPYBWH3PXyfX/Byt3e7OzN87yRJkiRJkiRJkiRJkiRJkiS9ZZf/vi3ldDc36uh/WtDmbGbVNi3r+6ysv2lpJzOqrtPiPl1NVn3cpuX9IH5Ycz6ubVrD8UTVh7SKzxNZF2kdO+J3OPUtHqWVfCFeWlMX1/u0kg3yik9px7ofPjs5wKxtWsuxWWY9Mcsss8zayyyzzDJrL7PMepNZm7tegVk/I3rlZf2OiJ5xWXfxoGVkVjRmVgxmVgxmVhRmVhRmVlRmVq/IrOgZmRUtI7OiMbNiMLNiMLOiMLOiMLOiMrN6RWZFz8isaBmZFY2ZFYOZFYOZFYWZFYWZFZWZ1SsyK3pGZkXLyKxozKwYzKz4xcxqzKww6/CzoNcW85d4g/zfGsh/+Ya8VTfkE0TPxOetznw6rchneeabT0G+JzLfqgdyDaIhF5Iacn2rZ+JqYGeunVbkSjNzXb4gdzGYez4DuUPWkNucDbn72jNxr7ozd/Yr8hwE89RIQZ6xYZ5IGsjzWw13CO/8sYp3NvBrRM+8k5SbP7fEc6fQU7pmzWOWWWaZtZdZZpll1l5mmfVC1gFOZoFmQaf+QGckQSdKQedvQaeVUWe7QSfhQecGUqcsQmdSQid4UuedUqfDQmfpUicPS5IkSZIkSZIkSZIkSZIkSXqNe5yG2bApU4+IAAAAAElFTkSuQmCC",

    grabVideo: function(videoconfig) {
        var vimeoinfo = new Object;
        vimeoinfo.type = "play_vimeo";
        vimeoinfo.title = __wp_utils__.escape(videoconfig.video.title);
        vimeoinfo.author = __wp_utils__.escape(videoconfig.video.owner.name);
        vimeoinfo.thumbnail = videoconfig.video.thumbs.base;
        vimeoinfo.duration = videoconfig.video.duration;
        vimeoinfo.videos = new Array;

        var videos = videoconfig.request.files.progressive;

        for(var i = 0; i < videos.length; i++)
            vimeoinfo.videos.push({"type": videos[i].quality + ", " + videos[i].mime, "url": videos[i].url });

        navigator.qt.postMessage(JSON.stringify(vimeoinfo));
    },

    clickGrab: function(touchevent) {
        var vmvideoelement = touchevent.target;

        if((vmvideoelement.tagName === "DIV") && (vmvideoelement.className.split(" ").indexOf("target") !== -1)) {
            vmvideoelement = vmvideoelement.parentElement;
            console.log(vmvideoelement.tagName + " " + vmvideoelement.className + " " + vmvideoelement.hasAttribute("data-config-url") + vmvideoelement.id)
        }

        if((vmvideoelement.tagName !== "DIV") || !vmvideoelement.hasAttribute("data-config-url"))
            return;

        var req = new XMLHttpRequest;

        req.onreadystatechange = function() {
            if(req.readyState === XMLHttpRequest.DONE) {
                var videoconfig = JSON.parse(req.responseText);
                __wp_vimeohelper__.grabVideo(videoconfig);
            }
        }

        req.open("GET", vmvideoelement.getAttribute("data-config-url"));
        req.send();
    }
};

if(__wp_utils__.getDomain() === "vimeo.com")
    document.addEventListener("touchend",  __wp_vimeohelper__.clickGrab, true);
