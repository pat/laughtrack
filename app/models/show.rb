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
    
    has sold_out_percent, rating
  end
  
  def tweets
    db.function("_design/laughtrack/_view/by_show", :key => id).collect { |doc|
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
  
  private
  
  def add_act_keyword
    keywords.create :words => "\"#{act_name}\"" unless act_name.blank?
  end
end
