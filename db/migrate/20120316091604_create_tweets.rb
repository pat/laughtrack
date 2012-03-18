class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string  :tweet_id
      t.string  :to_user_id
      t.string  :from_user_id
      t.string  :profile_image_url
      t.string  :source
      t.string  :text
      t.string  :from_user
      t.integer :show_id
      t.string  :classification
      t.boolean :confirmed, :default => false, :null => false
      t.boolean :ignore, :default => false, :null => false
      t.text    :raw
      t.integer :user_id
      t.timestamps
    end

    add_index :tweets, :classification
    add_index :tweets, :confirmed
    add_index :tweets, :ignore
    add_index :tweets, :show_id
    add_index :tweets, :user_id
    add_index :tweets, :tweet_id
  end
end
