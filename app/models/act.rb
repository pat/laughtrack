class Act < ActiveRecord::Base
  has_and_belongs_to_many :performers
  
  validates_presence_of :name
  
  before_validation :add_default_performer
  
  private
  
  def add_default_performer
    return unless performers.empty?
    
    performers << Performer.create(:name => name)
  end
end
