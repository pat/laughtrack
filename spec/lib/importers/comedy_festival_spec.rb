require 'spec_helper'

describe Importers::ComedyFestival do
  # before :each do
  #   @domain = 'http://www.comedyfestival.com.au'
  # end
  # 
  # describe '.import' do
  #   before :each do
  #     Importers::ComedyFestival.stub!(:import_2008 => nil, :import_2009 => nil)
  #   end
  #   
  #   it "should import 2008 records" do
  #     Importers::ComedyFestival.should_receive(:import_2008)
  #     
  #     Importers::ComedyFestival.import
  #   end
  #   
  #   it "should import 2009 records" do
  #     Importers::ComedyFestival.should_receive(:import_2009)
  #     
  #     Importers::ComedyFestival.import
  #   end
  # end
  # 
  # describe '.import_2008' do
  #   before :each do
  #     response = open('spec/fixtures/comedyfestival.2008.html') { |f| f.read }
  #     FakeWeb.register_uri(:get,
  #       %r{#{@domain}/season/2008/shows/a-z/.+},
  #       :response => response
  #     )
  #   end
  #   
  #   it "should create shows for each item found" do
  #     Importers::ComedyFestival.import_2008
  #     
  #     Show.count.should == 32
  #   end
  #   
  #   it "should not overwrite shows of the same name" do
  #     Importers::ComedyFestival.import_2008
  #     Importers::ComedyFestival.import_2008
  #     
  #     Show.count.should == 32
  #   end
  #   
  #   it "should request each letter page" do
  #     Importers::ComedyFestival.import_2008
  #     
  #     ('a'..'z').each do |letter|
  #       FakeWeb.should have_requested(:get,
  #         "#{@domain}/season/2008/shows/a-z/#{letter}"
  #       )
  #     end
  #   end
  #   
  #   it "should request the 'other' page" do
  #     Importers::ComedyFestival.import_2008
  #     
  #     FakeWeb.should have_requested(:get,
  #       "#{@domain}/season/2008/shows/a-z/other"
  #     )
  #   end
  # end
  # 
  # describe '.import_2009' do
  #   before :each do
  #     response = open('spec/fixtures/comedyfestival.2009.html') { |f| f.read }
  #     FakeWeb.register_uri(:get,
  #       %r{#{@domain}/season/2009/shows/a-z/letter/.+},
  #       :response => response
  #     )
  #   end
  #   
  #   it "should create shows for each item found" do
  #     Importers::ComedyFestival.import_2009
  #     
  #     Show.count.should == 30
  #   end
  #   
  #   it "should not overwrite shows of the same name" do
  #     Importers::ComedyFestival.import_2009
  #     Importers::ComedyFestival.import_2009
  #     
  #     Show.count.should == 30
  #   end
  #   
  #   it "should request each letter page" do
  #     Importers::ComedyFestival.import_2009
  #     
  #     ('a'..'z').each do |letter|
  #       FakeWeb.should have_requested(:get,
  #         "#{@domain}/season/2009/shows/a-z/letter/#{letter}"
  #       )
  #     end
  #   end
  #   
  #   it "should request the 'other' page" do
  #     Importers::ComedyFestival.import_2009
  #     
  #     FakeWeb.should have_requested(:get,
  #       "#{@domain}/season/2009/shows/a-z/letter/other"
  #     )
  #   end
  # end
  # 
  # describe '.import_2010' do
  #   before :each do
  #     response = open('spec/fixtures/comedyfestival.2010.html') { |f| f.read }
  #     FakeWeb.register_uri(:get,
  #       %r{#{@domain}/2010/season/shows/a-z/letter/([a-z]|other)/?$},
  #       :response => response
  #     )
  #     FakeWeb.register_uri(:get,
  #       "#{@domain}/2010/season/shows/a-z/letter/a/page/2/",
  #       :body => ''
  #     )
  #   end
  #   
  #   it "should create shows for each item found" do
  #     Importers::ComedyFestival.import_2010
  #     
  #     Show.count.should == 20
  #   end
  #   
  #   it "should not overwrite shows of the same name" do
  #     Importers::ComedyFestival.import_2010
  #     Importers::ComedyFestival.import_2010
  #     
  #     Show.count.should == 20
  #   end
  #   
  #   it "should request each letter page" do
  #     Importers::ComedyFestival.import_2010
  #     
  #     ('a'..'z').each do |letter|
  #       FakeWeb.should have_requested(:get,
  #         "#{@domain}/2010/season/shows/a-z/letter/#{letter}"
  #       )
  #     end
  #   end
  #   
  #   it "should request the 'other' page" do
  #     Importers::ComedyFestival.import_2010
  #     
  #     FakeWeb.should have_requested(:get,
  #       "#{@domain}/2010/season/shows/a-z/letter/other"
  #     )
  #   end
  #   
  #   it "should parse act details correctly" do
  #     Importers::ComedyFestival.import_2010
  #     
  #     show = Show.find(:first, :conditions => "name LIKE '%Mess Around%'")
  #     show.name.should == 'Mess Around'
  #     show.act.name.should == 'Adam Hills'
  #   end
  #   
  #   it "should parse additional pages" do
  #     Importers::ComedyFestival.import_2010
  #     
  #     FakeWeb.should have_requested(:get,
  #       "#{@domain}/2010/season/shows/a-z/letter/a/page/2/"
  #     )
  #   end
  # end
end
