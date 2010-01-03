class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.string :name
      t.integer :act_id
      t.string :status, :null => :false, :default => 'confirmed'
      t.timestamps
    end
    
    add_index :shows, :act_id
  end

  def self.down
    drop_table :shows
  end
end
