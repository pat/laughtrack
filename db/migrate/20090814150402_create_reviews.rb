class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.string  :name, :null => false
      t.integer :show_id
      t.float   :rating
      t.string  :source
      
      t.timestamps
    end
    
    add_index :reviews, :show_id
  end
  
  def self.down
    drop_table :reviews
  end
end
