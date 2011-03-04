class Festival < ActiveRecord::Base
  validates :name,      :presence => true
  validates :year,      :presence => true
  validates :starts_on, :presence => true
  validates :ends_on,   :presence => true
end
