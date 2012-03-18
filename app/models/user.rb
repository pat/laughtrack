class User < ActiveRecord::Base
  ALLOWED_USERS = %( pat laughtrack_au )
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable,
  # :database_authenticatable, :registerable, :recoverable, :rememberable,
  # :trackable, :validatable

  devise :omniauthable, :trackable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :username

  def self.load_from_oauth(token)
    username = token.info.nickname
    return nil unless ALLOWED_USERS.include? username

    User.find_or_create_by_username(username)
  end
end
