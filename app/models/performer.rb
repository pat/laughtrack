class Performer < ActiveRecord::Base
  has_and_belongs_to_many :acts
  
  validates_presence_of :name
  
  define_index do
    indexes name
    indexes acts.name, :as => :acts
  end
end
