class HomeController < ApplicationController
  expose(:shows)   {
    params[:query].blank? ? Show.order_by_score : Show.search(params[:query])
  }
end
