class CreateActs < ActiveRecord::Migration
  def self.up
    create_table :acts do |t|
      t.string :name
      t.string :status, :null => false, :default => 'confirmed'
      t.timestamps
    end
  end
  
  def self.down
    drop_table :acts
  end
end
