class CreateActsPerformers < ActiveRecord::Migration
  def self.up
    create_table :acts_performers, :id => false do |t|
      t.integer :act_id,        :null => false
      t.integer :performer_id,  :null => false
    end
    
    add_index :acts_performers, :act_id
    add_index :acts_performers, :performer_id
  end

  def self.down
    drop_table :acts_performers
  end
end
