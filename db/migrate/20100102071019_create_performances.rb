class CreatePerformances < ActiveRecord::Migration
  def self.up
    create_table :performances do |t|
      t.integer :show_id
      t.boolean :sold_out
      t.datetime :happens_at

      t.timestamps
    end
  end

  def self.down
    drop_table :performances
  end
end
