class ReviewersController < ApplicationController
  expose(:reviewers) {
    Reviewer.joins(:tweets).
      select('reviewers.*, COUNT(DISTINCT tweets.id) AS tweet_count').
      where('tweets.confirmed = ?', true).
      group('reviewers.id, reviewers.username, reviewers.created_at, reviewers.updated_at').
      order('COUNT(DISTINCT tweets.id) DESC, LOWER(username) ASC')
  }
  expose(:reviewer) { Reviewer.where(:username => params[:id]).first }
end
