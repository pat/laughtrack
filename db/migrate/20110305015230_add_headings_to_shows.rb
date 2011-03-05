class AddHeadingsToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :heading_one, :string
    add_column :shows, :heading_two, :string
  end
  
  def self.down
    remove_column :shows, :heading_two
    remove_column :shows, :heading_one
  end
end
