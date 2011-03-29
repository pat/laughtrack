class Reviewer < ActiveRecord::Base
  has_many :tweets
  
  validates :username, :presence => true, :uniqueness => true
  
  def tweet_count
    read_attribute(:tweet_count).to_i
  end
end
