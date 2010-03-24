class Show < ActiveRecord::Base
  include LaughTrack::CouchDb
  
  belongs_to :act
  has_many   :performances
  has_many   :keywords
  
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
    self.rating = LaughTrack::Wilson.new(
      positive_count, confirmed_tweet_count
    ).lower_bound * 100
  end
  
  def scrape_performances
    doc = Nokogiri::HTML open(url)
    time_node = doc.css(".show .rightCol p").detect { |para|
      para.text[/\d(:\d\d)?[ap]m/]
    }
    time_node ? time_node.text : "None: #{act_name} - #{name}"
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
end
