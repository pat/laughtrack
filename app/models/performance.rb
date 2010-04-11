class Performance < ActiveRecord::Base
  belongs_to :show
  
  validates_presence_of :show, :happens_at
  
  named_scope :for, lambda { |date|
    {:conditions => {:happens_at => date.beginning_of_day..date.end_of_day}}
  }
  named_scope :ordered,   :order => 'happens_at ASC'
  named_scope :available, :conditions => {:sold_out => false}
  
  after_save :update_show_sold_out_percent
  
  def sold_out!
    update_attributes(:sold_out => true)
  end
  
  def available!
    update_attributes(:sold_out => false)
  end
  
  private
  
  def update_show_sold_out_percent
    sold    = show.performances.select { |perf| perf.sold_out }.length
    percent = sold * 100.0 / show.performances.length
    
    show.update_attributes(:sold_out_percent => percent)
  end
end
