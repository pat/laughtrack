class AddUnconfirmedTweetCount < ActiveRecord::Migration
  def self.up
    add_column :shows, :unconfirmed_tweet_count, :integer
  end

  def self.down
    remove_column :shows, :unconfirmed_tweet_count
  end
end
