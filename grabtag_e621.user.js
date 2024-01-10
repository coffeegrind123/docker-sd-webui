// ==UserScript==
// @name         E621 Tag Grabber
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  Press CTRL+Q, copies tags to clipboard :3
// @author       Pandela
// @match        https://e621.net/posts/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=e621.net
// @grant        GM_setClipboard
// ==/UserScript==

document.addEventListener('keydown', function(event) {
    if (event.code == 'KeyQ' && (event.ctrlKey || event.metaKey)) {
        var out = "";
        var rating = document.querySelector("#post-rating-text").innerText;

        var artistCount = document.querySelectorAll("#tag-list > ul.artist-tag-list > li a.search-tag").length;
        for (let index = 0; index < artistCount; index++) {
            var artistTag = document.querySelector("#tag-list > ul.artist-tag-list > li:nth-child(" + (index + 1) + ") > a.search-tag");
            if (artistTag && artistTag.parentElement && artistTag.parentElement.parentElement) {
                var artistTags = artistTag.innerText;
                out += "by " + artistTags + ", ";
            }
        }

        out += rating + ", ";

        var copyrightCount = document.querySelectorAll("#tag-list > ul.copyright-tag-list > li a.search-tag").length;
        for (let index = 0; index < copyrightCount; index++) {
            var copyrightTag = document.querySelector("#tag-list > ul.copyright-tag-list > li:nth-child(" + (index + 1) + ") > a.search-tag");
            if (copyrightTag && copyrightTag.parentElement && copyrightTag.parentElement.parentElement) {
                var copyrightTags = copyrightTag.innerText;
                out += copyrightTags + ", ";
            }
        }

        var charCount = document.querySelectorAll("#tag-list > ul.character-tag-list > li a.search-tag").length;
        for (let index = 0; index < charCount; index++) {
            var characterTag = document.querySelector("#tag-list > ul.character-tag-list > li:nth-child(" + (index + 1) + ") > a.search-tag");
            if (characterTag && characterTag.parentElement && characterTag.parentElement.parentElement) {
                var characterTags = characterTag.innerText;
                out += characterTags + ", ";
            }
        }

        var speciesCount = document.querySelectorAll("#tag-list > ul.species-tag-list > li a.search-tag").length;
        for (let index = 0; index < speciesCount; index++) {
            var speciesTag = document.querySelector("#tag-list > ul.species-tag-list > li:nth-child(" + (index + 1) + ") > a.search-tag");
            if (speciesTag && speciesTag.parentElement && speciesTag.parentElement.parentElement) {
                var speciesTags = speciesTag.innerText;
                out += speciesTags + ", ";
            }
        }

        var generalCount = document.querySelectorAll("#tag-list > ul.general-tag-list > li a.search-tag").length;
        for (let index = 0; index < generalCount; index++) {
            var generalTag = document.querySelector("#tag-list > ul.general-tag-list > li:nth-child(" + (index + 1) + ") > a.search-tag");
            if (generalTag && generalTag.parentElement && generalTag.parentElement.parentElement) {
                var generalTags = generalTag.innerText;
                out += generalTags + ", ";
            }
        }

        var metaCount = document.querySelectorAll("#tag-list > ul.meta-tag-list > li a.search-tag").length;
        for (let index = 0; index < metaCount; index++) {
            var metaTag = document.querySelector("#tag-list > ul.meta-tag-list > li:nth-child(" + (index + 1) + ") > a.search-tag");
            if (metaTag && metaTag.parentElement && metaTag.parentElement.parentElement) {
                var metaTags = metaTag.innerText;
                out += metaTags + ", ";
            }
        }

        GM_setClipboard(out);
    }
});
