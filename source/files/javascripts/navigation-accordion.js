$( document ).ready( function() {
    "use strict";
    var navList = $( "nav.main > ul" );

    // Find nav links to current page
        // To make the regex, we transform the current page's pathname to:
        // - allow "/latest/" to also match any numerical version
        // - handle "/" and "/index.html" identically.
    var normalizedLocation = location.pathname.replace(/\/latest\//, "/(latest|[\\d\\.]+)/").replace(/(\/|\/index.html)$/, "/(index.html)?") + '$';
    var locationTest = new RegExp(normalizedLocation);
    var isLinkToCurrentPage = function(index, element) {
        return locationTest.test( $( element ).prop( "href" ) );
    };
    var navLinksToCurrentPage = navList.find("a").filter( isLinkToCurrentPage );

    var navSections = navList.find( "li:has(ul)" ); // an LI that contains a label followed by a list of contents
    var navSectionLabels = navSections.children( "strong" );
    var activeNavSections = navLinksToCurrentPage.parentsUntil(navList).filter(navSections); // can include parents of the parent section

    // Disable links to current page
    navLinksToCurrentPage.addClass("disabled-nav-link");
    navLinksToCurrentPage.on("click", function(e) { e.preventDefault(); } );

    // Add custom events to nav sections. Since we can have sections within sections
    // with independent expansion state, we shouldn't let these events bubble up.
    navSections.on( {
        // Allow nav sections to toggle their sublist if you click the ± sign or label
        "click": function(e) {
            if (e.target === this || e.target === $(this).children('strong')[0]) {
                e.stopPropagation();
                $(this).trigger('toggleNavSection');
            }
        },
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

    // Add a "toggle all" button if there is at least one navSection
    if ( navSections.length > 0 ) {
        navList.before( '<p style="text-align: center;"><a href="#" id="toggle-all-nav-sections">(↓ expand all ↓)</a></p>' );
    }

    // Enable the "toggle all" button
    $( "a#toggle-all-nav-sections" ).on("click", function(e) {
        e.preventDefault();
        if ( $( this ).text() === '(↓ expand all ↓)' ) {
            navSections.trigger("setExpanded");
            $( this ).text('(↑ collapse all ↑)');
        } else {
            navSections.trigger("setHidden");
            $( this ).text('(↓ expand all ↓)');
        }
    });

});

