class StorePositiveTweetCounts < ActiveRecord::Migration
  def self.up
    add_column :shows, :positive_tweet_count, :integer
  end

  def self.down
    remove_column :shows, :positive_tweet_count
  end
end
