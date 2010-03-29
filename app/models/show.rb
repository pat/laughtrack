class Show < ActiveRecord::Base
  include LaughTrack::CouchDb
  
  belongs_to :act
  has_many   :performances, :order => 'happens_at ASC'
  has_many   :keywords
  has_many   :show_histories
  
  validates_presence_of :name
  validates_presence_of :act, :if => :confirmed?
  
  named_scope :limited,  :limit => 5
  named_scope :popular,  :order => 'sold_out_percent DESC'
  named_scope :rated,    :order => 'rating DESC'
  named_scope :featured, :conditions => {:featured => true}
  named_scope :random,   :order => 'RAND() ASC'
  
  after_create :add_act_keyword
  
  define_index do
    indexes name,                  :sortable => true
    indexes act.name, :as => :act, :sortable => true
    
    has sold_out_percent, rating, tweet_count, featured
    has confirmed_tweet_count, unconfirmed_tweet_count
  end
  
  def self.update_tweet_counts
    all.each do |show|
      show.update_tweet_count
      show.save
    end
  end
  
  def self.write_histories
    all.each do |show|
      show.write_history
    end
  end
  
  def self.scrape_performances
    all.each do |show|
      show.scrape_performances
    end
  end
  
  def tweets(options = {})
    view('confirmed_by_show', options).collect { |doc|
      db.get doc.id
    }
  end
  
  def unconfirmed_tweets
    view('unconfirmed_by_show').collect { |doc|
      db.get doc.id
    }
  end
  
  def random_tweet
    docs = db.function "_design/laughtrack/_view/positive_by_show",
      :key        => id,
      :descending => true
    return nil unless docs.first
    
    db.get docs.first.id
  end
  
  def confirmed?
    status == 'confirmed'
  end
  
  def act_name
    act ? act.name : ''
  end
  
  def act_name=(act_name)
    self.act = act_name.blank? ? nil : Act.find_or_create_by_name(act_name)
  end
  
  def related
    @related ||= begin
      act_ids = act.performers.collect { |perf| perf.act_ids }.flatten.uniq
      Show.find(:all, :conditions => {:act_id => act_ids}) - [self]
    end
  end
  
  def feature!
    update_attributes(:featured => true)
  end
  
  def unfeature!
    update_attributes(:featured => false)
  end
  
  def update_tweet_count
    self.tweet_count              = view("by_show").length
    self.confirmed_tweet_count    = view("confirmed_by_show").length
    self.unconfirmed_tweet_count  = view("unconfirmed_by_show").length
    self.positive_tweet_count     = positive_count
    
    self.rating = LaughTrack::Wilson.new(
      positive_count, confirmed_tweet_count
    ).lower_bound * 100
  end
  
  def write_history
    update_tweet_count
    
    show_histories.create(
      :sold_out_percent       => sold_out_percent,
      :rating                 => rating,
      :confirmed_tweet_count  => confirmed_tweet_count,
      :positive_tweet_count   => positive_tweet_count,
      :day                    => Date.today
    )
  end
  
  def scrape_performances
    doc = Nokogiri::HTML open(url)
    time_node = doc.css(".show .rightCol p").detect { |para|
      para.text[/\d(:\d\d)?[ap]m/]
    }
    times = time_node ? time_node.text : ""
    doc.css(".showCalendar .preview").each { |node|
      add_scraped_performance node.text.strip.to_i, times
    }
    doc.css(".showCalendar .show").each { |node|
      add_scraped_performance node.text.strip.to_i, times
    }
  end
  
  private
  
  def add_act_keyword
    keywords.create :words => "\"#{act_name}\"" unless act_name.blank?
  end
  
  def view(name, options = {})
    db.function("_design/laughtrack/_view/#{name}", options.merge(:key => id))
  end
  
  def positive_count
    view("positive_by_show").length
  end
  
  def add_scraped_performance(day, times)
    month = day > 20 ? 3 : 4
    date  = Date.new(2010, month, day)
    
    LaughTrack::TimeParser.new(times).performances_for_day(date).each do |time|
      next if performances.find(:first, :conditions => {:happens_at => time})
      
      performances.create :happens_at => time
    end
  end
  
  def days(string)
    match = string.scan(/(\w\w\w)\-(\w\w\w)/).first
    if match.nil?
      [day_integer string[/\b(\w\w\w)\b/]]
    else
      (day_integer(match.first)..day_integer(match.last)).to_a
    end
  end
  
  def day_integer(string)
    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].index(string) || (0..6).to_a
  end
end
