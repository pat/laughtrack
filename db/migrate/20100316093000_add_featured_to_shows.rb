class AddFeaturedToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :featured, :boolean, :default => false
    
    add_index :shows, :featured
  end
  
  def self.down
    remove_column :shows, :featured
    
    remove_index :shows, :featured
  end
end
