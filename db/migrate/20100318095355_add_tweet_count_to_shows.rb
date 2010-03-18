class AddTweetCountToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :tweet_count, :integer
  end

  def self.down
    remove_column :shows, :tweet_count
  end
end
