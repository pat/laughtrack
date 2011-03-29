class AddReviewerIdToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :reviewer_id, :integer
    add_index  :tweets, :reviewer_id
  end
  
  def self.down
    remove_index  :tweets, :reviewer_id
    remove_column :tweets, :reviewer_id
  end
end
