require 'open-uri'

class Keyword < ActiveRecord::Base
  include LaughTrack::CouchDb
  
  belongs_to :show
  
  validates_presence_of :show, :words
  
  def self.import_oldest
    Keyword.all(:limit => 60, :order => 'imported_at ASC').each do |keyword|
      keyword.import
    end
  end
  
  def import
    logger.debug "IMPORTING #{words}"
    url = "http://search.twitter.com/search.json?q=#{ CGI.escape words }"
    JSON.load(open(url))['results'].each do |tweet|
      next if tweet_stored? tweet['id']
      
      db.save tweet.merge(
        :keywords => words,
        :show_id  => show_id
      )
    end
    
    update_attributes(:imported_at => Time.now)
  end
  
  private
  
  def tweet_stored?(id)
    !db.function('_design/laughtrack/_view/tweets', :key => id).empty?
  end
end
