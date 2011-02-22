class SettingDefaultForSoldOut < ActiveRecord::Migration
  def self.up
    change_column :performances, :sold_out, :boolean, :default => false
    Performance.update_all ['sold_out = ?', false], 'sold_out IS NULL'
  end

  def self.down
    change_column :performances, :sold_out, :boolean
  end
end
