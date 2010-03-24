require 'spec_helper'

describe ShowHistory do
  describe '#valid?' do
    it "should be invalid without a show" do
      history = ShowHistory.make_unsaved :show => nil
      history.should have(1).error_on(:show)
    end
    
    it "should be invalid without a sold out percentage" do
      history = ShowHistory.make_unsaved :sold_out_percent => nil
      history.should have(1).error_on(:sold_out_percent)
    end
    
    it "should be invalid without a rating" do
      history = ShowHistory.make_unsaved :rating => nil
      history.should have(1).error_on(:rating)
    end
    
    it "should be invalid without a tweet count" do
      history = ShowHistory.make_unsaved :confirmed_tweet_count => nil
      history.should have(1).error_on(:confirmed_tweet_count)
    end
    
    it "should be invalid without a positive tweet count" do
      history = ShowHistory.make_unsaved :positive_tweet_count => nil
      history.should have(1).error_on(:positive_tweet_count)
    end
    
    it "should be invalid without a day" do
      history = ShowHistory.make_unsaved :day => nil
      history.should have(1).error_on(:day)
    end
  end
  
  describe '.create' do
    it "should overwrite histories for the same day and show" do
      history = ShowHistory.make
      history = ShowHistory.make :show => history.show
      
      ShowHistory.count(:conditions => {:day => history.day}).should == 1
    end
    
    it "should not overwrite other shows' histories" do
      history = ShowHistory.make
      history = ShowHistory.make :show => Show.make
      
      ShowHistory.count(:conditions => {:day => history.day}).should == 2
    end
  end
end
