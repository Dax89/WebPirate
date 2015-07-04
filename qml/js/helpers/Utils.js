var __wp_utils__ = {
    escape: function(s) {
        return s.replace(/'/g, "&#39;");
    },

    unescape: function(s) {
        return s.replace("&#39;", "'");
    },
}
