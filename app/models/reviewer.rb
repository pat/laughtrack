class Reviewer < ActiveRecord::Base
  has_many :tweets
  
  validates :username, :presence => true, :uniqueness => true
  
  def tweet_count
    read_attribute(:tweet_count).to_i
  end
  
  def name
    json['name'] || username
  end
  
  private
  
  def json
    @json ||= Nestful.get "https://api.twitter.com/1/users/show.json",
      :format  => :json,
      :headers => {'User-Agent' => 'laughtrack.com.au'},
      :params  => {:screen_name => username}
  rescue
    @json ||= {}
  end
end
