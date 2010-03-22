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
        :keywords       => words,
        :show_id        => show_id,
        :classification => classification(tweet['text']),
        :ignore         => ignore(tweet['text'])
      )
    end
    
    update_attributes(:imported_at => Time.now)
  end
  
  private
  
  def tweet_stored?(id)
    !db.function('_design/laughtrack/_view/tweets', :key => id).empty?
  end
  
  def classification(text)
    case text
    when /not very funny/i, /complete twat/i, /not a fan/i
      'negative'
    when /very funny/i, /brilliant/i, /five stars/i, /funniest/i, /so+ funny/i,
      /amazing/i, /worth( a)? watch/i, /awesome/i, /hilarious/i, /real gem/i,
      /fantastic/i, /loved (his|her|their|the) show/i, /incredible/i,
      /absolute delight/i
      'positive'
    else
      nil
    end
  end
  
  def ignore(text)
    case text
    when /#micf/i, /#laughtrack/i
      false
    when /\bRT\b/, /spicks (and|&) specks/i, /I favorited a YouTube video/i,
      /check this video out/i, /Sarah Millican's Support Group/i,
      /worldsoccertweets/i, /the bubble/i, /ru\s?paul/i,
      /rated a youtube video/i, /#spicks(and|&)specks/i,
      /Northcote \(So Hungover\)/i, /left a comment for/i, /Oklahoma City/i,
      /scored \d+ points/i, /The 7pm Project/i, /Nick Sun @ Station 59/i,
      /thank god you'?re here/i, /the 100 club: Artists/i
      true
    else
      false
    end
  end
end
