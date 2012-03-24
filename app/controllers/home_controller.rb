class HomeController < ApplicationController
  expose(:shows)  {
    params[:query].blank? ? Show.order_by_score : Show.search(params[:query])
  }
  expose(:tweets) { Tweet.visible.positive.order('created_at DESC').limit(8) }

  def index
    return unless pjax?

    render :partial => 'shows/shows',
      :object => shows,
      :locals => {:featured => nil}
  end
end
