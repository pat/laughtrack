class AddScoreToShows < ActiveRecord::Migration
  def change
    add_column :shows, :score, :float
    add_index  :shows, :score
  end
end
