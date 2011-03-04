class Show < ActiveRecord::Base
  FestivalStart = Time.local(2010, 3, 23)
  
  belongs_to :act
  has_many   :performances, :order => 'happens_at ASC'
  has_many   :keywords
  has_many   :show_histories
  has_many   :tweets
  
  validates_presence_of :name
  validates_presence_of :act, :if => :confirmed?
  
  scope :limited,       limit(5)
  scope :very_limited,  limit(3)
  scope :popular,       order('sold_out_percent DESC')
  scope :rated,         order('rating DESC')
  scope :featured,      where(:featured => true)
  scope :random,        order('RAND() ASC')
  scope :available,     where('sold_out_percent < 100.0')
  scope :still_showing, joins(:performances).
    group("shows.id").having("MAX(happens_at) > NOW()")
  scope :tonight,       lambda {
    where(["DATE(performances.happens_at) = ?", Date.today]).
    joins(:performances)
  }
  
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
  
  def self.validate_performances
    all.each do |show|
      show.validate_performances
    end
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
      Show.where(:act_id => act_ids).to_a - [self]
    end
  end
  
  def feature!
    update_attributes(:featured => true)
  end
  
  def unfeature!
    update_attributes(:featured => false)
  end
  
  def update_tweet_count
    self.tweet_count              = tweets.count
    self.confirmed_tweet_count    = tweets.confirmed.count
    self.unconfirmed_tweet_count  = tweets.unconfirmed.count
    self.positive_tweet_count     = positive_count
    
    self.rating = LaughTrack::Wilson.new(
      smart_positive_count, smart_confirmed_tweet_count
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
    if url
      logger.info "\/\/\/ URL#{url}\n"
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
  end
  
  def validate_performances
    doc = Nokogiri::HTML open(url)
    minimum_shows = doc.css(".showCalendar .preview").length +
                    doc.css(".showCalendar .show").length
    
    if performances.length < minimum_shows
      puts "Missing Performances for #{act_name} - #{name}"
    end
  rescue
    puts "Error requesting show information for #{act_name} - #{name}"
  end
  
  private
  
  def add_act_keyword
    keywords.create :words => "\"#{act_name}\"" unless act_name.blank?
  end
  
  def positive_count(options = {})
    tweets.positive.confirmed.count
  end
  
  def smart_positive_count
    tweets.positive.confirmed.count.inject(0.0) do |count, tweet|
      count + (tweet.created_at > FestivalStart ? 1.0 : 0.5)
    end
  end
  
  def smart_confirmed_tweet_count
    tweets.confirmed.count.inject(0.0) do |count, object|
      count + (tweet.created_at > FestivalStart ? 1.0 : 0.5)
    end
  end
  
  def add_scraped_performance(day, times)
    month = day > 20 ? 3 : 4
    date  = Date.new(2010, month, day)
    
    LaughTrack::TimeParser.new(times).performances_for_day(date).each do |time|
      next if performances.where(:happens_at => time).first
      
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
