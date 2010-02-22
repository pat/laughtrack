require 'spec/spec_helper'

describe Keyword do
  describe '.import_oldest' do
    it "should request just 60 keywords" do
      Keyword.should_receive(:find) do |mode, options|
        options[:limit].should == 60
        []
      end
      
      Keyword.import_oldest
    end
    
    it "should order by imported_at ascending" do
      Keyword.should_receive(:find) do |mode, options|
        options[:order].should == 'imported_at ASC'
        []
      end
      
      Keyword.import_oldest
    end
    
    it "should call import on each keyword returned" do
      keywords = (1..10).collect { |i|
        stub('keyword').as_null_object
      }
      keywords.each { |k| k.should_receive(:import) }
      Keyword.stub!(:find => keywords)
      
      Keyword.import_oldest
    end
  end
  
  describe '#valid?' do
    it "should be invalid without a show" do
      keyword = Keyword.make_unsaved :show => nil
      keyword.should have(1).error_on(:show)
    end
    
    it "should be invalid without any words" do
      keyword = Keyword.make_unsaved :words => nil
      keyword.should have(1).error_on(:words)
    end
  end
  
  describe '#import' do
    before :each do
      @database = stub('database', :function => []).as_null_object
      Throne::Database.stub!(:new => @database)
      
      FakeWeb.register_uri :get, /search\.twitter\.com/,
        :body => '{"results":[{"text":"foo","id":"bar"}]}'
        
      @keyword = Keyword.make
    end
    
    it "should load the twitter search results" do
      @keyword.import
      
      FakeWeb.should have_requested(:get, /search\.twitter\.com/)
    end
    
    it "should add the tweet to CouchDB" do
      @database.should_receive(:save) do |hash|
        hash['text'].should == 'foo'
        hash['id'].should == 'bar'
      end
      
      @keyword.import
    end
    
    it "should not add the tweet to CouchDB if it already exists" do
      @database.should_not_receive(:save)
      @database.stub!(:function => ['foo'])
      
      @keyword.import
    end
    
    it "should set the show id for the tweet" do
      @database.should_receive(:save) do |hash|
        hash[:show_id].should == @keyword.show_id
      end
      
      @keyword.import
    end
    
    it "should update the imported_at time" do
      @keyword.imported_at = 3.day.ago
      
      @keyword.import
      
      @keyword.imported_at.to_date.should == Date.today
    end
  end
end
