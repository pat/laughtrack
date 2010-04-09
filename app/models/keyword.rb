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
    if outside_window?
      update_attributes(:imported_at => Time.now)
      return
    end
    
    logger.debug "IMPORTING #{words}"
    url = "http://search.twitter.com/search.json?q=#{ CGI.escape words }"
    JSON.load(open(url))['results'].each do |tweet|
      next if tweet_stored? tweet['id'], show_id
      
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
  
  def tweet_stored?(id, show_id)
    !db.function('_design/laughtrack/_view/tweets', :key => [id, show_id]).empty?
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
    when /Win free tickets to over \d\d/i
      true
    when /#micf/i, /#laughtrack/i, /@laughtrack_au/i
      false
    when /\bRT\b/, /spicks (and|&) specks/i, /I favou?rited a YouTube video/i,
      /check this video out/i, /Sarah Millican's Support Group/i,
      /worldsoccertweets/i, /the bubble/i, /ru\s?paul/i,
      /rated a youtube video/i, /#spicks(and|&)specks/i,
      /Northcote \(So Hungover\)/i, /left a comment for/i, /Oklahoma City/i,
      /scored \d+ points/i, /The 7pm Project/i, /Nick Sun @ Station 59/i,
      /thank god you'?re here/i, /the 100 club: Artists/i,
      /can you please send a autograph picture/i, /Jag har favoritmarkerat/i,
      /Thank God Your Here/i, /essence festival 2010/i, /hyundai malfunction/i,
      /not here for your entertainment/i, /this is the tom green show/i
      true
    else
      false
    end
  end
  
  def outside_window?
    return false if show.performances.empty?
    
    Date.today.to_time < show.performances.first.happens_at ||
    show.performances.last.happens_at < 5.days.ago
  end
end
