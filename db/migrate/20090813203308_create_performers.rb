class CreatePerformers < ActiveRecord::Migration
  def self.up
    create_table :performers do |t|
      t.string :name
      t.string :country
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :performers
  end
end
