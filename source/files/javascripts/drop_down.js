$(document).ready(function() {
   $('.drop-down-trigger').click(function() {
     var navElement = $(this).parent().parent();
     navElement.toggleClass('active');
     navElement.hover(
       function(){},
       function(){
       $(this).removeClass('active');
     });
     return false;
   });
   
   $('li.with-submenu > a').click(function(){
     if ($(this).attr("href") == "#"){
       var navElement = $(this).parent().find('.drop-down-trigger').click();       
     }
   });
});