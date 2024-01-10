// ==UserScript==
// @name         E621 Tag Grabber
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Press CTRL+Q, copies tags to clipboard :3
// @author       Pandela
// @match        https://e621.net/posts/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=e621.net
// @grant        GM_setClipboard
// ==/UserScript==
document.addEventListener('keydown', function(event) {
    if (event.code == 'KeyQ' && (event.ctrlKey || event.metaKey)) {
        //document.querySelector("#static-index > div:nth-child(3) > form > div > input[type=submit]:nth-child(3)").click()
        var out = "";
        var rating = document.querySelector("#post-rating-text").innerText

        var count = document.querySelector("#tag-list > ul.artist-tag-list > li:nth-child(1) > a.search-tag").parentElement.parentElement.children.length
        for (let index = 0; index < count; index++) {
            var a = index + 1
            var artist_tags = document.querySelector("#tag-list > ul.artist-tag-list > li:nth-child(" + a + ") > a.search-tag").innerText
            out += "by " + artist_tags + ", "
        }

        //add rating after artist tag
        out += rating + ", "

        var copyright = document.querySelector("#tag-list > h2.copyright-tag-list-header.tag-list-header");
        if (copyright == null) {
            //do nothing
        }
        if (copyright != null) {
            var count1 = document.querySelector("#tag-list > ul.copyright-tag-list > li:nth-child(1) > a.search-tag").parentElement.parentElement.children.length
            for (let index = 0; index < count1; index++) {
                var a1 = index + 1
                var copyright_tags = document.querySelector("#tag-list > ul.copyright-tag-list > li:nth-child(" + a1 + ") > a.search-tag").innerText
                //add copyright tags if they exist
                out += copyright_tags + ", "
            }
        }

        var char = document.querySelector("#tag-list > h2.character-tag-list-header.tag-list-header");
        if (char == null) {
            //do nothing
        }
        if (char != null) {
            var count5 = document.querySelector("#tag-list > ul.character-tag-list > li:nth-child(1) > a.search-tag").parentElement.parentElement.children.length
            for (let index = 0; index < count5; index++) {
                var a5 = index + 1
                var character_tags = document.querySelector("#tag-list > ul.character-tag-list > li:nth-child(" + a5 + ") > a.search-tag").innerText
                out += character_tags + ", "
            }
        }

        var count2 = document.querySelector("#tag-list > ul.species-tag-list > li:nth-child(1) > a.search-tag").parentElement.parentElement.children.length
        for (let index = 0; index < count2; index++) {
            var a2 = index + 1
            var species_tags = document.querySelector("#tag-list > ul.species-tag-list > li:nth-child(" + a2 + ") > a.search-tag").innerText
            out += species_tags + ", "
        }
        var count3 = document.querySelector("#tag-list > ul.general-tag-list > li:nth-child(1) > a.search-tag").parentElement.parentElement.children.length
        for (let index = 0; index < count3; index++) {
            var a3 = index + 1
            var general_tags = document.querySelector("#tag-list > ul.general-tag-list > li:nth-child(" + a3 + ") > a.search-tag").innerText
            out += general_tags + ", "

        }

        var meta = document.querySelector("#tag-list > h2.meta-tag-list-header.tag-list-header");
        if (meta == null) {
            //do nothing
        }
        if (meta != null) {
            var count4 = document.querySelector("#tag-list > ul.meta-tag-list > li:nth-child(1) > a.search-tag").parentElement.parentElement.children.length
            for (let index = 0; index < count4; index++) {
                var a4 = index + 1
                var meta_tags = document.querySelector("#tag-list > ul.meta-tag-list > li:nth-child(" + a4 + ") > a.search-tag").innerText
                out += meta_tags + ", "
            }
        }
        //console.log(out);
        GM_setClipboard(out);

    }

});
