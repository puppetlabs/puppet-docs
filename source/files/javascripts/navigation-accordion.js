$( document ).ready( function() {
    "use strict";
    var navList = $( "nav.main > div#subCol > ul:not(#doc-navigation)" );
    var navLinksToCurrentPage = navList.find( "span.currentpage" );
    var navSections = navList.find( "li:has(ul)" ); // an LI that contains a label followed by a list of contents
    var navSectionLabels = navSections.children( "strong" );
    var activeNavSections = navLinksToCurrentPage.parentsUntil(navList).filter(navSections); // can include parents of the parent section

    // Add custom events to nav sections. Since we can have sections within sections
    // with independent expansion state, we shouldn't let these events bubble up.
    navSections.on( {
        "toggleNavSection": function(e) {
            e.stopPropagation();
            // Toggle the list item bullet
            $( this ).toggleClass("hidden-nav expanded-nav");
            // Slide the contents of the section
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

    // Clicking section labels will toggle their section
    navSectionLabels.on("click", function() {
        $( this ).parent("li").trigger("toggleNavSection");
    });

    // Enable an "expand all" button
    $( "a#expand-all-nav-sections" ).on("click", function(e) {
        e.preventDefault();
        navSections.trigger("setExpanded");
    });

});

