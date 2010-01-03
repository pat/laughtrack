class AddSoldOutPercentToShow < ActiveRecord::Migration
  def self.up
    add_column :shows, :sold_out_percent, :decimal,
      :precision => 6, :scale => 3, :default => 0.0
  end

  def self.down
    remove_column :shows, :sold_out_percent
  end
end
