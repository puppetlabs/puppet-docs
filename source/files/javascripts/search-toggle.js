/**
 * Opens and closes the search slider which contains the search input.
 */
 function toggleSearchOpenClosed (e) {
  e.preventDefault();
  var
    search_button       = $('.global-header__nav-main__item.search'),
    search_slider       = $('.search-slider'),
    logo_col            = $('.global-header__row__col.__col1'),
    search_button_pos   = search_button.offset().left,
    logo_col_pos        = logo_col.offset().left,
    logo_col_width      = logo_col.outerWidth(),
    total_width         = search_button_pos - (logo_col_pos + logo_col_width);

  // Toggle menu
  if (search_slider.outerWidth() <= 0 && e.type == 'mouseenter') {

    // Show search
    search_slider.stop(true).show().animate({width: total_width}, {duration: 200, complete: function() {

      // Add body class
      $('body').addClass('search-open');

      // Set data flag
      search_slider.data('open', true);
    }});
  }
  if (e.type == 'mouseleave') {

    // Hide search
    search_slider.stop(true).animate({width: 0}, {duration: 200, complete: function() {

      // Remove body class
      $('body').removeClass('search-open');

      // Set data flag
      search_slider.data('open', false);

      // Hide slider
      search_slider.hide();
    }});
  }
}

$(document).ready(function() {
  $('.global-header__nav-main__item.search').mouseenter(function(evt) {
    toggleSearchOpenClosed(evt);
  }).mouseleave(function(evt) {
    toggleSearchOpenClosed(evt);
  });
});
