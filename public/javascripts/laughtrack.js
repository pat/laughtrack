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

  $("#more_tweets").tipsy({gravity: 'n'});

});

// usage:   myList = new tweetList(show_id, id_of_list_element_to_update, number_of_tweets_to_show_off_the_bat)
tweetList = Class.create({
  init: function(id, list_id, init_show, per_page, total_tweets){
    this.show_id = id;
    this.list_id = list_id;
    this.per_page = per_page;
    this.total_tweets = total_tweets;
    this.nextTweets(init_show);
  },
  show_id: 0,
  last_tweet_displayed: 0,
  list_id: "tweet_list",
  tweets: {},
  per_page: 15,
  total_tweets: 0,
  list: $("#"+this.list_id),
  get_list_id: function(){ return this.list_id; },
  loadShowTweets: function(id, limit) {
    this.tweets = jQuery.parseJSON($.ajax({url: '/shows/'+id+'/tweets.json?paginate[skip]='+this.last_tweet_displayed+'&paginate[limit]='+limit, dataType: "json", async: false }).responseText);
  },
  nextTweets: function(per_page) {
    this.loadShowTweets(this.show_id, per_page);
    for (i=0;i<this.tweets.length;i++) {
      this.addTweet(this.tweets[i].tweet);
      this.last_tweet_displayed++;
    }
    this.showHidden();
    if (this.last_tweet_displayed==this.total_tweets) $("#more_tweets").hide();
  },
  addTweet: function(tweet) {
    $('<li/>')
      .attr({
        style: "display: none",
        "class": "hidden "+tweet.classification,
        id: "tweet_"+tweet.tweet_id
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
          href: "http://twitter.com/"+tweet.from_user+"/status/"+tweet.tweet_id
          })
        .html(tweet.created_at_to_s+" ago")
      )
      .appendTo("#"+this.list_id)
  },
  showHidden: function() {
    $($("#"+this.list_id+" li.hidden")).removeClass("hidden").fadeIn(800);
  }
});

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-2475317-12']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();