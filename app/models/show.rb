class Show < ActiveRecord::Base
  belongs_to :act
  has_many   :performances
  
  validates_presence_of :name
  validates_presence_of :act, :if => :confirmed?
  
  named_scope :limited, :limit => 5
  named_scope :popular, :order => 'sold_out_percent DESC'
  named_scope :rated,   :order => 'rating DESC'
  
  define_index do
    indexes name
    indexes act.name, :as => :act
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
end
