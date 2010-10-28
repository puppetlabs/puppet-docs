$(document).ready(function() {
    $("*:contains('&')", document.body)
        .contents()
        .each(
            function() {
                if( this.nodeType == 3 ) {
                    $(this)
                        .replaceWith( this
                            .nodeValue
                            .replace( /&/g, '<span class="ampersand">&amp;</span>' )
                        );
                }
            }
        );
});