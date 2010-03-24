class CreateShowHistories < ActiveRecord::Migration
  def self.up
    create_table :show_histories do |t|
      t.integer :show_id,          :null => false
      t.decimal :sold_out_percent, :precision => 6, :scale => 3, :default => 0.0
      t.decimal :rating,           :precision => 5, :scale => 2, :default => 0.0
      t.integer :confirmed_tweet_count, :default => 0
      t.integer :positive_tweet_count,  :default => 0
      t.date    :day
      t.timestamps
    end
    
    add_index :show_histories, :show_id
  end

  def self.down
    drop_table :show_histories
  end
end
