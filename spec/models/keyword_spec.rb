require 'spec_helper'

describe Keyword do
  describe '#valid?' do
    it "should be invalid without a show" do
      keyword = Keyword.make :show => nil
      keyword.should have(1).error_on(:show)
    end
    
    it "should be invalid without any words" do
      keyword = Keyword.make :words => nil
      keyword.should have(1).error_on(:words)
    end
  end
  
  describe '#import' do
    let(:keyword) { Keyword.make! }
    
    before :each do
      FakeWeb.register_uri :get, /search\.twitter\.com/,
        :body => '{"results":[{"text":"foo","id":"bar"}]}'
    end
    
    it "should load the twitter search results" do
      keyword.import
      
      FakeWeb.should have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should add the tweet" do
      keyword.tweets.should_receive(:create)
      keyword.import
    end
    
    it "should not add the tweet if it already exists" do
      Tweet.stub! :where => stub('conditions', :count => 1)
      
      keyword.tweets.should_not_receive(:create)
      keyword.import
    end
    
    it "should update the imported_at time" do
      keyword.imported_at = 3.day.ago
      
      keyword.import
      
      keyword.imported_at.to_date.should == Date.today
    end
    
    it "should not check for shows that have not happened" do
      keyword.show.performances.create(:happens_at => 3.days.from_now)
      keyword.import
      
      FakeWeb.should_not have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should not check for shows that finished five days ago" do
      keyword.show.performances.create(:happens_at => 6.days.ago)
      keyword.import
      
      FakeWeb.should_not have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should check for shows that finished four days ago" do
      keyword.show.performances.create(:happens_at => 4.days.ago)
      keyword.import
      
      FakeWeb.should have_requested(:get, /search\.twitter\.com/)
    end
  end
end
