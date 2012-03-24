$(document).ready(function() {
  if (!jQuery.support.pjax)
    return;

  $('body.home .navbar-search').submit(function() {
    var form = $(this);
    jQuery.pjax({
      url: form.attr('action') + '?' + form.serialize(),
      container: '#shows'
    });
    return false;
  });

  $('#shows a').pjax('#main-content');
})
