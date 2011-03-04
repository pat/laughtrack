class CreateFestivals < ActiveRecord::Migration
  def self.up
    create_table :festivals do |t|
      t.string  :name
      t.integer :year
      t.date    :starts_on
      t.date    :ends_on
      t.timestamps
    end
  end
  
  def self.down
    drop_table :festivals
  end
end
