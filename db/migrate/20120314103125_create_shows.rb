class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :heading_one
      t.string :heading_two

      t.timestamps
    end
  end
end
