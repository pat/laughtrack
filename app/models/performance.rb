class Performance < ActiveRecord::Base
  belongs_to :show
  
  validates_presence_of :show, :happens_at
  
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
