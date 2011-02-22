class Performance < ActiveRecord::Base
  belongs_to :show
  
  validates_presence_of :show, :happens_at
  
  scope :for, lambda { |date|
    where(:happens_at => date.beginning_of_day..date.end_of_day)
  }
  scope :ordered,   order('happens_at ASC')
  scope :available, where(:sold_out => false)
  scope :sold_out,  where(:sold_out => true)
  
  after_save :update_show_sold_out_percent
  
  def sold_out!
    update_attributes(:sold_out => true)
  end
  
  def available!
    update_attributes(:sold_out => false)
  end
  
  def self.next_available
    self.for(Date.today+1.day).ordered.available.first
  end
  
  private
  
  def update_show_sold_out_percent
    return if show.performances.count == 0
    
    sold    = show.performances.sold_out.count
    percent = sold * 100.0 / show.performances.count
    
    show.update_attributes(:sold_out_percent => percent)
  end
end
