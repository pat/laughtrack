require 'open-uri'

class Keyword < ActiveRecord::Base
  belongs_to :show
  has_many :tweets
  
  validates_presence_of :show, :words
  
  scope :oldest_imports,
    order("coalesce(imported_at, timestamp '2001-01-01 00:00') ASC")
  
  def self.import_oldest
    Keyword.limit(100).oldest_imports.each do |keyword|
      keyword.import
    end
  end
  
  def import
    if outside_window?
      update_attributes(:imported_at => Time.now)
      return
    end
    
    logger.debug "IMPORTING #{words}"
    url = "http://search.twitter.com/search.json?q=#{ CGI.escape words }"
    JSON.load(open(url))['results'].each do |tweet|
      next if tweet_stored? tweet['id_str']
      
      tweets.create :json => tweet, :autoignore => true
    end
    
    update_attributes(:imported_at => Time.now)
  end
  
  private
  
  def tweet_stored?(id)
    Tweet.where(:tweet_id => id, :show_id => show_id).count > 0
  end
  
  def outside_window?
    return false if show.performances.empty?
    
    Date.today.to_time < show.performances.first.happens_at ||
    show.performances.last.happens_at < 5.days.ago
  end
end
