require 'spec/spec_helper'

describe Importers::ComedyFestival do
  describe '.import' do
    before :each do
      Importers::ComedyFestival.stub!(:import_2008 => nil, :import_2009 => nil)
    end
    
    it "should import 2008 records" do
      Importers::ComedyFestival.should_receive(:import_2008)
      
      Importers::ComedyFestival.import
    end
    
    it "should import 2009 records" do
      Importers::ComedyFestival.should_receive(:import_2009)
      
      Importers::ComedyFestival.import
    end
  end
  
  describe '.import_2008' do
    before :each do
      response = open('spec/fixtures/comedyfestival.2008.html') { |f| f.read }
      FakeWeb.register_uri(:get,
        %r{http://www.comedyfestival.com.au/season/2008/shows/a-z/.+},
        :response => response
      )
    end
    
    it "should create shows for each item found" do
      Importers::ComedyFestival.import_2008
      
      Show.count.should == 32
    end
    
    it "should not overwrite shows of the same name" do
      Importers::ComedyFestival.import_2008
      Importers::ComedyFestival.import_2008
      
      Show.count.should == 32
    end
    
    it "should request each letter page" do
      Importers::ComedyFestival.import_2008
      
      ('a'..'z').each do |letter|
        FakeWeb.should have_requested(:get,
          "http://www.comedyfestival.com.au/season/2008/shows/a-z/#{letter}"
        )
      end
    end
    
    it "should request the 'other' page" do
      Importers::ComedyFestival.import_2008
      
      FakeWeb.should have_requested(:get,
        "http://www.comedyfestival.com.au/season/2008/shows/a-z/other"
      )
    end
  end
  
  describe '.import_2009' do
    before :each do
      response = open('spec/fixtures/comedyfestival.2009.html') { |f| f.read }
      FakeWeb.register_uri(:get,
        %r{http://www.comedyfestival.com.au/season/2009/shows/a-z/letter/.+},
        :response => response
      )
    end
    
    it "should create shows for each item found" do
      Importers::ComedyFestival.import_2009
      
      Show.count.should == 30
    end
    
    it "should not overwrite shows of the same name" do
      Importers::ComedyFestival.import_2009
      Importers::ComedyFestival.import_2009
      
      Show.count.should == 30
    end
    
    it "should request each letter page" do
      Importers::ComedyFestival.import_2009
      
      ('a'..'z').each do |letter|
        FakeWeb.should have_requested(:get,
      "http://www.comedyfestival.com.au/season/2009/shows/a-z/letter/#{letter}"
        )
      end
    end
    
    it "should request the 'other' page" do
      Importers::ComedyFestival.import_2009
      
      FakeWeb.should have_requested(:get,
        "http://www.comedyfestival.com.au/season/2009/shows/a-z/letter/other"
      )
    end
  end
end
