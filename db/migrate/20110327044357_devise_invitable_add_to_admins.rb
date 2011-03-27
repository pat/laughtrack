class DeviseInvitableAddToAdmins < ActiveRecord::Migration
  def self.up
    change_table :admins do |t|
      t.string   :invitation_token, :limit => 20
      t.datetime :invitation_sent_at
      t.index    :invitation_token # for invitable
    end
    
    # And allow null encrypted_password and password_salt:
    change_column :admins, :encrypted_password, :string, :null => true
    change_column :admins, :password_salt,      :string, :null => true
  end
  
  def self.down
    remove_column :admins, :invitation_sent_at
    remove_column :admins, :invitation_token
  end
end
