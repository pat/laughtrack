class ReviewersController < ApplicationController
  expose(:reviewers) {
    Reviewer.joins(:tweets).
      select('reviewers.*, COUNT(DISTINCT tweets.id) AS tweet_count').
      group('reviewers.id, reviewers.username, reviewers.created_at, reviewers.updated_at').
      order('COUNT(DISTINCT tweets.id) DESC')
  }
end
