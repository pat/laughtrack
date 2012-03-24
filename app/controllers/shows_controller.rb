class ShowsController < ApplicationController
  expose(:show)
  expose(:tweets) { show.tweets.visible.order('created_at DESC') }
end
