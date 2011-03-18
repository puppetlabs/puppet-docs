$(document).ready(function() {
    $( 'th' ).each( function() {
        $( this ).html( $( this ).html().replace(/_/g, ' '));
    })
});