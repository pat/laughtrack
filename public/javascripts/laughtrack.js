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

// usage:   myList = new tweetList(show_id, id_of_list_element_to_update, number_of_tweets_to_show_off_the_bat)
tweetList = Class.create({
  init: function(id, list_id, init_show){
    this.list_id = list_id;
    this.loadShowTweets(id);
    this.nextTweets(init_show);
  },
  last_tweet_displayed: -1,
  list_id: "tweet_list",
  tweets: {},
  list: $("#"+this.list_id),
  get_list_id: function(){ return this.list_id; },
  loadShowTweets: function(id) {
    this.tweets = jQuery.parseJSON($.ajax({url: '/shows/'+id+'/tweets.json', dataType: "json", async: false }).responseText);
  },
  nextTweets: function(per_page) {
    var currently_at = this.last_tweet_displayed;
    for (i=this.last_tweet_displayed+1;i<=currently_at+per_page;i++) {
      if (i<this.tweets.length) {
        this.addTweet(this.tweets[i]);
        this.last_tweet_displayed = i;
      }
    }
    this.showHidden();
  },
  addTweet: function(tweet) {
    $('<li/>')
      .attr({
        style: "display: none",
        "class": "hidden "+tweet.classification,
        id: "tweet_"+tweet.id
      })
      .append($('<span/>').attr({ 
          "class": "review_rating",
          title: tweet.classification
        })
        .append(tweet.classification)
      )
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
      .appendTo("#"+this.list_id)
  },
  showHidden: function() {
    $($("#"+this.list_id+" li.hidden")).removeClass("hidden").fadeIn(800);
  }
});
