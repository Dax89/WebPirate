var __wp_nightmode__ = {
    enabled: false,

    createStyle: function() {
        var nmnode = document.getElementById("__wp_css_nightmode__");
    
        if(nmnode)
          return;

        var css = "html.__wp_nightmode__ { -webkit-filter: contrast(68%) brightness(108%) invert(); }" +
                  "html.__wp_nightmode__ iframe { -webkit-filter: invert(); }" + // Keep iframes normal
                  "html.__wp_nightmode__ object { -webkit-filter: invert(); }" + // Keep Flash items normal
                  "html.__wp_nightmode__ video { -webkit-filter: invert(); }" +  // Keep HTML5 Videos normal
                  "html.__wp_nightmode__ img { -webkit-filter: invert(); }" ;    // Keep images normal

        var head = document.getElementsByTagName("head")[0];
        var style = document.createElement("style");

        style.id = "__wp_css_nightmode__";
        style.type = "text/css";
        style.appendChild(document.createTextNode(css));
        head.appendChild(style);
      },

      switchMode: function(newstate) {
          if(__wp_nightmode__.enabled === newstate)
              return;

          __wp_nightmode__.enabled = newstate;
          __wp_nightmode__.createStyle();

          var html = document.getElementsByTagName("html")[0];

          if(html.className.indexOf("__wp_nightmode__") === -1)
              html.className += " " + "__wp_nightmode__";
          else
              html.className = html.className.replace("__wp_nightmode__", "");
      }
};
