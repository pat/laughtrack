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

tweetList = Class.create({
  init: function(id, list_id, init_show){
    this.list_id = list_id;
    this.loadShowTweets(id);
    this.nextTweets(init_show);
  },
  last_tweet_displayed: -1,
  list_id: "test",
  tweets: {},
  list: $("#"+this.list_id),
  get_list_id: function(){ return this.list_id; },
  loadShowTweets: function(id) {
    this.tweets = jQuery.parseJSON($.ajax({url: '/shows/'+id+'/tweets.json', dataType: "json", async: false }).responseText);
  },
  nextTweets: function(per_page) {
    for (i=this.last_tweet_displayed+1;i<=this.last_tweet_displayed+per_page;i++) {
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
        "class": "hidden",
        id: "tweet_"+tweet.id
      })
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
