// This JS only handles the quick nav menu in the sidebar.
$( document ).ready( function() {
    "use strict";
    // If your click bubbles up to the actual body of the quick nav menu,
    // and the menu is visible, prevent the click from closing the menu.
    $( "li.with-submenu > dl" ).on("click", function(e) {
        if ( $( this ).parent().hasClass("active") ) { e.stopPropagation(); }
    });
    // If you click the label of the quick nav (i.e. outside the body of the nav menu),
    // toggle visibility of the menu.
    $( "li.with-submenu" ).on("click", function(e) {
        $( this ).toggleClass("active");
        e.stopPropagation();
    });

    // If you click anywhere else (that is, the other two things didn't stop
    // propagation of the event), hide the menu.
    $( document ).on("click", function(e) {
        $( "li.with-submenu" ).removeClass("active");
    });

});
