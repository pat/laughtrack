class HomeController < ApplicationController
  def index
    @popular  = Show.popular.limited.available.still_showing
    @rated    = Show.rated.limited
    # @featured = Show.featured.random.first || Show.random.first
    @tonight  = Show.tonight.rated.popular.available.very_limited
    @recent_tweets    = @rated.collect(&:random_tweet) #FIXME:  Needs a recent tweets method on shows  >  CouchDB stuff
    # @tweet    = @featured.random_tweet
    @calendar_date = Time.parse("#{params[:date]}-01") || Time.now
    @performance_dates = Performance.find(:all, :conditions => ["happens_at BETWEEN ? AND ?", @calendar_date, @calendar_date+1.month]).group_by{|p| p.happens_at.to_date}
  end
  
  def about
    @title = "About"
  end
end
