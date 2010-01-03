class AddRatingToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :rating, :decimal,
      :precision => 3, :scale => 2, :default => 2.5
  end

  def self.down
    remove_column :shows, :rating
  end
end
