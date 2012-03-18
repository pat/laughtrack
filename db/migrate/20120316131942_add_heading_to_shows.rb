class AddHeadingToShows < ActiveRecord::Migration
  def change
    add_column :shows, :heading, :string
  end
end
