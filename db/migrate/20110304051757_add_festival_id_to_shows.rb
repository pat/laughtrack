class AddFestivalIdToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :festival_id, :integer, :null => false
    add_index  :shows, :festival_id
  end
  
  def self.down
    remove_index  :shows, :column_name
    remove_column :shows, :festival_id
  end
end
