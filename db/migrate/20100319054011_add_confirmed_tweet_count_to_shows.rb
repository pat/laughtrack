class AddConfirmedTweetCountToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :confirmed_tweet_count, :integer
  end

  def self.down
    remove_column :shows, :confirmed_tweet_count
  end
end
