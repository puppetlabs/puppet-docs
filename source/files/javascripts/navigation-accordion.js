$( document ).ready( function() {
    var navList = $( "nav.main > div#subCol > ul:not(.doc-navigation)" );
    var navLinksToCurrentPage = navList.find( "span.currentpage" );
    var navSections = navList.find( "li:has(ul)" ); // an LI that contains a label followed by a list of contents
    var navSectionLabels = navSections.children( "strong" );
    // var navSectionLists = navSections.children("ul");
    // var navSectionLists = navSectionLabels.next("ul");
    var activeNavSections = navLinksToCurrentPage.parentsUntil(navList).filter(navSections); // can include parents of the parent section

    // Add custom events to nav sections. Since we can have sections within sections
    // with independent expansion state, we shouldn't let these events bubble up.
    navSections.on( {
        "toggleNavSection": function(e) {
            e.stopPropagation();
            $( this ).trigger("toggleNavBullet").trigger("slideNavContents");
        },
        "toggleNavBullet": function(e) {
            e.stopPropagation();
            $( this ).toggleClass("hidden-nav expanded-nav");
        },
        "slideNavContents": function(e) {
            // You can use a second function argument to toggle the bullet after
            // the slide finishes, but that always felt laggy to me.
            e.stopPropagation();
            $( this ).children("ul").slideToggle( 200 );
        },
        "setExpanded": function(e) {
            e.stopPropagation();
            $( this ).addClass("expanded-nav").removeClass("hidden-nav");
            $( this ).children("ul").css("display", "");
        },
        "setHidden": function(e) {
            e.stopPropagation();
            $( this ).addClass("hidden-nav").removeClass("expanded-nav");
            $( this ).children("ul").css("display", "none");
        }
    });

    // Initialize all nav sections
    navSections.trigger("setHidden");
    // Expand any sections that contain the current page
    activeNavSections.trigger("setExpanded");

    // Allow section labels to collapse their section
    navSectionLabels.on("click", function() {
        $( this ).parent("li").trigger("toggleNavSection");
    });

    // Enable an "expand all" button
    $( "a#expand-all-nav-sections" ).on("click", function(e) {
        e.preventDefault();
        navSections.trigger("setExpanded");
    });

});

