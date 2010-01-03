require 'spec/spec_helper'

describe Importers::GroggySquirrel do
  describe '.import' do
    before :each do
      feed = open('spec/fixtures/thegroggysquirrel.xml') { |f| f.read }
      FakeWeb.register_uri(:get,
        'http://www.thegroggysquirrel.com/atom',
        :response => feed
      )
    end
    
    it "should create unpaired reviews from the RSS feed" do
      Importers::GroggySquirrel.import
      
      Review.count.should == 15
    end
    
    it "should set the name of the review from the entry titles" do
      Importers::GroggySquirrel.import
      
      Review.first.name.should == "Ali McGregor's Late-nite Variety-Nite Night"
    end
    
    it "should set the source to the entry urls" do
      Importers::GroggySquirrel.import
      
      Review.first.source.should == 'http://www.thegroggysquirrel.com/articles/2009/08/09/2009-edinburgh-fringe-reviews/ali-mcgregors-late-nite-variety-nite-night/'
    end
    
    it "should not overwrite existing reviews" do
      Importers::GroggySquirrel.import
      Importers::GroggySquirrel.import
      
      Review.count.should == 15
    end
  end
end
