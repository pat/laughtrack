class HomeController < ApplicationController
  def index
    @popular  = Show.popular.limited
    @rated    = Show.rated.limited
    @featured = Show.featured.random.first || Show.random.first
    @tweet    = @featured.random_tweet
  end
  
  def about
    @title = "About"
  end
end
