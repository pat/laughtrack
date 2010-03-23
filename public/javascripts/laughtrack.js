jQuery(function($) {
  

  // stripe tables
  $('tr:odd').removeClass('even');
  $('tr:even' ).addClass('even');

  // highlight rows
  $('tr').mouseenter(function() {
    $(this).addClass('highlight');
  }).mouseleave(function() {
    $(this).removeClass('highlight');
  });

});

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-2475317-12']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
