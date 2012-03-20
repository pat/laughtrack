window.focusedRow = $('table tbody tr:first-child');
window.focusedRow.addClass('active');

$(document).on('keydown', function(event) {
  if (window.focusedRow.length == 0) return;

  switch(event.which) {
    case 87:
      toggleAndFocus('wait');
      break;
    case 73:
      toggleAndFocus('ignore');
      break;
    case 75:
      toggleAndFocus('keep');
      break;
    case 78:
      toggleAndFocus('negative');
      break;
    case 80:
      toggleAndFocus('positive');
      break
  }
});

toggleAndFocus = function(value) {
  window.scrollTo(0, window.focusedRow.position().top - 250);
  window.focusedRow.find('input[value=' + value + ']').click();
  window.focusedRow.removeClass('active');

  window.focusedRow = window.focusedRow.next();
  window.focusedRow.addClass('active');
}

$("select[name='tweet[show_id]']").chosen();

$('.attach-tweet form').on('submit', function() {
  form = $(this);
  jQuery.post(form.attr('action'), form.serialize(), function(data) {
    form.parent('div.attach-tweet').remove();
    var counter = $('#tweet-counter');
    counter.text((parseInt(counter.text()) - 1).toString());
  });
  return false;
});
