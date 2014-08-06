$(document).ready(function() {
   $(document).click(function(e) {
     var clickedElement = $(e.target);
     var navElement = clickedElement.parent().parent();

     if (!navElement.hasClass('active')) {
       $('li.with-submenu').removeClass('active');
     }

     if (clickedElement.hasClass('drop-down-trigger') || clickedElement.is('li.with-submenu > a[href="#"] *')) {
       e.preventDefault();
       navElement.toggleClass('active');
       return false;
     }
     // navElement.hover(
     //   function(){},
     //   function(){
     //   $(this).removeClass('active');
     // });
   });

   // $('li.with-submenu > a').click(function(){
   //   if ($(this).attr("href") == "#"){
   //     var navElement = $(this).parent().find('.drop-down-trigger').click();
   //   }
   // });
});
