class CreateReviewers < ActiveRecord::Migration
  def self.up
    create_table :reviewers do |t|
      t.string :username
      t.timestamps
    end
    
    add_index :reviewers, :username
  end
  
  def self.down
    remove_index :reviewers, :username
    
    drop_table :reviewers
  end
end
