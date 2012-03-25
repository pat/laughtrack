$(document).ready(function() {
  var updateShowsFromSearch = function(event) {
    var query = $('.navbar-search input').val();
    var regex = new RegExp(query, 'im')

    $('#shows li').each(function() {
      var li = $(this);
      if (li.text().match(regex))
        li.show();
      else
        li.hide();
    });
  };

  updateShowsFromSearch();
  $('.navbar-search input').on('keyup', updateShowsFromSearch);
  $('.navbar-search').submit(function() {
    return false;
  });

  if (!jQuery.support.pjax)
    return;

  $('.about a').pjax({
    container: '#main .container',
    timeout:   2000
  });

  $('body.home #shows a').pjax({
    container: '#main .container',
    timeout:   2000
  }).live('click', function() {
    var list_item = $(this).parent('li');
    list_item.siblings().removeClass('featured');
    list_item.addClass('featured');
  });
});
