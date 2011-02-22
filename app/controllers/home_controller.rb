class HomeController < ApplicationController
  include LaughTrack::CouchDb
  
  def index
    @popular           = Show.popular.limited
    @rated             = Show.rated.limited
    @tonight           = Show.tonight.rated.popular.available.very_limited
    @recent_tweets     = recent_tweets
    @calendar_date     = Time.parse("#{params[:date]}-01") || Time.now
    @performance_dates = Performance.
      where(:happens_at => @calendar_date..(@calendar_date+1.month)).
      group_by { |performance| performance.happens_at.to_date }
  end
  
  def about
    @title = "About"
  end
  
  private
  
  def recent_tweets
    tweet_pointers.collect { |pointer| db.get pointer.id }
  end
  
  def tweet_pointers
    db.function "_design/laughtrack/_view/confirmed_by_time",
      :limit      => 5,
      :descending => true
  end
end
