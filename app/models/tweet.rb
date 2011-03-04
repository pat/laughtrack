class Tweet < ActiveRecord::Base
  belongs_to :show
  belongs_to :keyword
  
  before_validation :set_from_json,         :on => :create  
  before_validation :set_show_from_keyword, :on => :create
  before_validation :set_classification,    :on => :create
  before_validation :set_ignore,            :on => :create
  
  scope :confirmed,    where(:confirmed => true)
  scope :unconfirmed,  where(:confirmed => false)
  scope :positive,     where(:classification => 'positive')
  scope :negative,     where(:classification => 'negative')
  scope :unclassified, where('classification IS NULL')
  
  attr_accessor :json, :autoignore
  
  def self.import(url, show_id)
    match = url.match /\/(\w+)\/statuse?s?\/(\d+)/
    user  = match[1]
    id    = match[2].to_i
    
    api = "http://api.twitter.com/1/statuses/user_timeline.json?count=200&screen_name=#{user}"
    tweet = JSON.load(open(api)).detect { |hash|
      hash['id'] == id
    }
    
    create :json => tweet, :show_id => show_id unless tweet.nil?
  end
  
  def ignored?
    ignore?
  end
  
  private
  
  def set_from_json
    return if json.nil?
    
    self.tweet_id          = json['id_str']
    self.to_user_id        = json['to_user_id_str']
    self.from_user_id      = json['from_user_id_str']
    self.profile_image_url = json['profile_image_url']
    self.source            = json['source']
    self.text              = json['text']
    self.from_user         = json['from_user']
    self.raw               = json.to_s
    self.created_at        = json['created_at']
  end
  
  def set_show_from_keyword
    self.show_id ||= keyword.show_id
  end
  
  def set_classification
    self.classification ||= case text
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
  
  def set_ignore
    self.ignore = case text
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
    end if autoignore
    
    true
  end
end
