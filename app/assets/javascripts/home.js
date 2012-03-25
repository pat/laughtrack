$(document).ready(function() {
  var updateShowsFromSearch = function(event) {
    var query = $('body.home. .navbar-search input').val();
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
  $('body.home. .navbar-search input').on('keyup', updateShowsFromSearch);
  $('body.home .navbar-search').submit(function() {
    return false;
  });

  if (!jQuery.support.pjax)
    return;

  $('body.home #shows a').pjax({
    container: '#main',
    timeout:   2000
  }).live('click', function() {
    var list_item = $(this).parent('li');
    list_item.siblings().removeClass('featured');
    list_item.addClass('featured');
  });
});
