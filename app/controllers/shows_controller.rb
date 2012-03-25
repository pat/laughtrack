class ShowsController < ApplicationController
  expose(:shows)    { Show.order_by_score }
  expose(:the_show) { Show.find params[:id] }
  expose(:tweets)   { the_show.tweets.visible.order('created_at DESC') }

  def show
    return unless pjax?

    render :partial => 'tweets/tweets', :object => tweets
  end
end
