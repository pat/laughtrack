class ChangeRatingPrecision < ActiveRecord::Migration
  def self.up
    change_column :shows, :rating, :decimal,
      :precision => 5, :scale => 2, :default => 0.0
  end

  def self.down
    change_column :shows, :rating, :decimal,
      :precision => 3, :scale => 2, :default => 2.5
  end
end
