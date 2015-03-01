var __wp_vimeohelper__ = {
    playbutton: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAAEsBAMAAACLU5NGAAAAIVBMVEUAAAAjHyAjHyA4NTaopqcjHyBxb3AjHyAjHyD////U09SUDTPUAAAACXRSTlMA1ZnT92boHg06O1hfAAACJUlEQVR42u3cMUscQRiA4UAIpp0cIZDKS5O006YLUyWVSRDrKe3Owl78DdN80yoD/ksVsfPYBWH3PXyfX/Byt3e7OzN87yRJkiRJkiRJkiRJkiRJkiS9ZZf/vi3ldDc36uh/WtDmbGbVNi3r+6ysv2lpJzOqrtPiPl1NVn3cpuX9IH5Ycz6ubVrD8UTVh7SKzxNZF2kdO+J3OPUtHqWVfCFeWlMX1/u0kg3yik9px7ofPjs5wKxtWsuxWWY9Mcsss8zayyyzzDJrL7PMepNZm7tegVk/I3rlZf2OiJ5xWXfxoGVkVjRmVgxmVgxmVhRmVhRmVlRmVq/IrOgZmRUtI7OiMbNiMLNiMLOiMLOiMLOiMrN6RWZFz8isaBmZFY2ZFYOZFYOZFYWZFYWZFZWZ1SsyK3pGZkXLyKxozKwYzKz4xcxqzKww6/CzoNcW85d4g/zfGsh/+Ya8VTfkE0TPxOetznw6rchneeabT0G+JzLfqgdyDaIhF5Iacn2rZ+JqYGeunVbkSjNzXb4gdzGYez4DuUPWkNucDbn72jNxr7ozd/Yr8hwE89RIQZ6xYZ5IGsjzWw13CO/8sYp3NvBrRM+8k5SbP7fEc6fQU7pmzWOWWWaZtZdZZpll1l5mmfVC1gFOZoFmQaf+QGckQSdKQedvQaeVUWe7QSfhQecGUqcsQmdSQid4UuedUqfDQmfpUicPS5IkSZIkSZIkSZIkSZIkSXqNe5yG2bApU4+IAAAAAElFTkSuQmCC",

    playVideo: function(vimeoinfo) {
        navigator.qt.postMessage(vimeoinfo); /* Forward directly */
    },

    getVideo: function() {
        var vmregex = new RegExp("http[s]*://[www]*[\\.]*vimeo\\.com.*/([0-9]+)");

        if(!vmregex.test(document.location.href))
            return;

        var cap = vmregex.exec(document.location.href);
        var element = document.getElementById("clip_" + cap[1]);

        if(!element)
            return;

        var videos = document.getElementsByTagName("video");

        if(!videos.length)
            return;

        var title =  element.parentElement.querySelector("h2[class*='title']");
        var thumbnail = element.querySelector("div[data-thumb]");

        var vimeoinfo = new Object;
        vimeoinfo.type = "play_vimeo";
        vimeoinfo.title = title ? title.innerText : "";
        vimeoinfo.thumbnail = thumbnail ? thumbnail.getAttribute("data-thumb") : "";
        vimeoinfo.videourl = videos[0].src;

        __wp_grabberbuilder__.createPlayer(element.firstElementChild, "vm", "__wp_vimeohelper__.playRequested('" + JSON.stringify(vimeoinfo) + "')", __wp_vimeohelper__.playbutton);
    },

    getEmbeddedVideos: function() {

    }
};
