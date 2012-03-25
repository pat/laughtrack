class HomeController < ApplicationController
  expose(:shows)  { Show.order_by_score }
  expose(:tweets) { Tweet.visible.positive.order('created_at DESC').limit(8) }

  def index
    return unless pjax?

    render :partial => 'shows/shows',
      :object => shows,
      :locals => {:featured => nil}
  end

  def about
    return unless pjax?

    render :partial => 'home/about'
  end
end
