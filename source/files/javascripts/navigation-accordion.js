$(document).ready(function() {
    
    var current_nav_section = $('#subCol ul').children('li').find('span.currentpage').parent().parent().parent();
    $(current_nav_section).addClass('expanded-nav')

    //Collection of li in the top-level ul - lis which contain strong tags
    var collapsed_nav_sections = current_nav_section.siblings()
    collapsed_nav_sections.find('ul').css('display', 'none');
    $(collapsed_nav_sections).removeClass('expanded-nav').addClass('hidden-nav')

    //Clickable top-level li
    var section_header = $('#subCol ul li').find('strong');
    $(section_header).css('cursor', 'pointer');

    $(section_header).live('click', toggle_nav_section)

    function toggle_nav_section (e) {
    	e.preventDefault();
   
    	toggle_section = $(e.target).parent().find('ul')

    	$(toggle_section).slideToggle( function() {
    		if($(e.target).parent().hasClass('expanded-nav')) {
    			$(e.target).parent().removeClass("expanded-nav").addClass("hidden-nav");
    		}
    		else {
    			$(e.target).parent().removeClass("hidden-nav").addClass("expanded-nav");
    		}
    	});

    }   
});