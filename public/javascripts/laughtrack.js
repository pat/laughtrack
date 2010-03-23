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

function loadTweets(id) {
  $.getJSON('/shows/'+id+'/tweets.json',
    function(data) {
      $.each(data, function(i,tweet){
        $('<li/>')
          .attr("style", "display: none")
          .append($('<img/>').attr({ 
              src: tweet.profile_image_url,
              "class": "twitter_profile",
              alt: tweet.from_user
            })
          )
          .append('<span class="arrow">◀</span>')
          .append('<a target="_blank" class="from_user" href="http://www.twitter.com/'+tweet.from_user+'">'+tweet.from_user+'</a> ')
          .append(tweet.text)
          .append($('<a/>')
            .attr({
              "class": "when",
              href: "http://twitter.com/"+tweet.from_user+"/status/"+tweet.id
              })
            .html(tweet.created_at+" ago")
          )
          .appendTo("#show_tweets")
          .fadeIn(800)
          
        if ( i == 5 ) return false;
      });
    }
  );
}