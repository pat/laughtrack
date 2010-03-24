class ShowHistory < ActiveRecord::Base
  belongs_to :show
  
  validates_presence_of :show, :sold_out_percent, :rating,
    :confirmed_tweet_count, :positive_tweet_count, :day
  
  before_create :clear_duplicates
  
  private
  
  def clear_duplicates
    ShowHistory.destroy_all :day => day, :show_id => show_id
  end
end
