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

$(function() {

  var list_id, tweets = {};
  
  tweetList = {function(id) {
    this.init(id);
  }
  $.extend(tweetList.prototype, {
    init: function(id, list_id){
      console.log('loaded');
      $.extend(this, {list_id: function(){ return list_id }});
      this.loadShowTweets(id);
      this.moreButton();
    },
    list: $("#"+this.list_id),
    get_list_id: function(){ return this.list_id; },
    loadShowTweets: function(id) {
      // $.getJSON('/shows/'+id+'/tweets.json');
      this.tweets = $.getJSON('/shows/'+id+'/tweets.json').responseText;
      return true;
    },
    nextTweets: function() {
      $.each(this.tweets, function(i,tweet){
        if (i > 15) return false;
        this.addTweet(tweet);
      });    
    },
    addTweet: function(tweet) {
      $('<li/>')
        .attr({
          // style: "display: none",
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
      $($("#"+this.list_id+" li.hidden")).attr("class", "").fadeIn(800);
    },
    moreButton: function() {
      console.log("id:  "+this.list_id);
      console.log($("#"+this.list_id).next());
      if ($("#"+this.list_id).next().className ="more_tweets") {
        console.log($("#"+this.list_id).next());
      }
    }
  });
};
