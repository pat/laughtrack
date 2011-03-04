class AddMicfIdToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :micf_id, :integer, :null => false
    add_index  :shows, :micf_id
  end
  
  def self.down
    remove_index  :shows, :micf_id
    remove_column :shows, :micf_id
  end
end
