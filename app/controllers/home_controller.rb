class HomeController < ApplicationController
  def index
    @popular = Show.popular.limited
    @rated   = Show.rated.limited
  end
end
