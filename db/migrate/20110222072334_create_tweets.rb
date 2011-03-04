class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string  :tweet_id
      t.string  :to_user_id
      t.string  :from_user_id
      t.string  :profile_image_url
      t.string  :source
      t.string  :text
      t.string  :from_user
      t.integer :keyword_id
      t.integer :show_id
      t.string  :classification
      t.boolean :ignore,    :null => false, :default => false
      t.boolean :confirmed, :null => false, :default => false
      t.text    :raw
      t.timestamps
    end
    
    add_index :tweets, :tweet_id
    add_index :tweets, :from_user_id
    add_index :tweets, :keyword_id
    add_index :tweets, :show_id
    add_index :tweets, :classification
    add_index :tweets, :ignore
    add_index :tweets, :confirmed
  end
  
  def self.down
    remove_index :tweets, :confirmed
    remove_index :tweets, :ignore
    remove_index :tweets, :classification
    remove_index :tweets, :show_id
    remove_index :tweets, :keyword_id
    remove_index :tweets, :from_user_id
    remove_index :tweets, :tweet_id
    
    drop_table :tweets
  end
end
