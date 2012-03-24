$(document).ready(function() {
  if (!jQuery.support.pjax)
    return;

  $('body.home .navbar-search').submit(function() {
    var form = $(this);
    jQuery.pjax({
      url:       form.attr('action') + '?' + form.serialize(),
      container: '#shows',
      timeout:   2000
    });
    return false;
  });

  $('#shows a').pjax('#main-content').live('click', function() {
    var list_item = $(this).parent('li');
    list_item.siblings().removeClass('featured');
    list_item.addClass('featured');
  });
});
