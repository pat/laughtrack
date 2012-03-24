class HomeController < ApplicationController
  expose(:shows)  {
    params[:query].blank? ? Show.order_by_score : Show.search(params[:query])
  }
  expose(:tweets) { Tweet.visible.positive.order('random()').limit(5) }
end
