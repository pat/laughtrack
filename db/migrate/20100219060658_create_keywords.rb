class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.integer  :show_id, :null => false
      t.string   :words
      t.timestamps
      t.datetime :imported_at
    end
    
    add_index :keywords, :show_id
  end
  
  def self.down
    drop_table :keywords
  end
end
