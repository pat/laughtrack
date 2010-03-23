require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Show do
  describe '.create' do
    it "should add a keyword with the act's name" do
      show = Show.make
      show.keywords.first.words.should == "\"#{show.act_name}\""
    end
    
    it "should not create a keyword if the act name is nil" do
      show = Show.make :act => nil, :status => 'imported'
      show.keywords.should be_empty
    end
  end
  
  describe '#valid?' do
    it "should create a new instance given valid attributes" do
      Show.make_unsaved.should be_valid
    end

    it "should be invalid without a name" do
      show = Show.make_unsaved :name => nil
      show.should have(1).error_on(:name)
    end

    it "should be invalid without an act" do
      show = Show.make_unsaved :act => nil
      show.should have(1).error_on(:act)
    end
    
    it "should be valid without an act with a status of imported" do
      show = Show.make_unsaved :act => nil
      show.status = 'imported'
      show.should be_valid
    end
  end
  
  describe '#status' do
    it "should default to 'confirmed'" do
      Show.new.status.should == 'confirmed'
    end
  end
  
  describe '#limited' do
    it "should return a maximum of five results" do
      6.times { Show.make }
      Show.limited.length.should == 5
    end
  end
  
  describe '#popular' do
    it "should return shows ranked by selling out percentage" do
      a = Show.make :sold_out_percent => 30.0
      b = Show.make :sold_out_percent => 20.0
      c = Show.make :sold_out_percent => 40.0
      
      Show.popular.should == [c, a, b]
    end
  end
  
  describe '#rated' do
    it "should return shows ranked by their rating" do
      a = Show.make :rating => 3.0
      b = Show.make :rating => 2.0
      c = Show.make :rating => 4.0
      
      Show.rated.should == [c, a, b]
    end
  end
  
  describe '#act_name' do
    it "should return the act's name" do
      show = Show.make_unsaved
      show.act_name.should == show.act.name
    end
    
    it "should return a blank string if there's no act" do
      show = Show.make_unsaved :act => nil
      show.act_name.should == ''
    end
  end
  
  describe '#act_name=' do
    it "should find and use an act named with the given value" do
      act = Act.make
      show = Show.make_unsaved :act => nil
      show.act_name = act.name
      
      show.act.should == act
    end
    
    it "should create a new act if none exist with that name" do
      show = Show.make_unsaved :act => nil
      show.act_name = 'foo'
      
      show.act.name.should == 'foo'
    end
    
    it "should not create an act if the provided value is nil" do
      show = Show.make_unsaved :act => nil
      show.act_name = nil
      
      show.act.should be_nil
    end
    
    it "should not create an act if the provided value is an empty string" do
      show = Show.make_unsaved :act => nil
      show.act_name = ''
      
      show.act.should be_nil
    end
  end
  
  describe '#related' do
    before :each do
      scod        = Performer.make :name => 'Scott Edgar'
      tripod      = Act.make :performers => [scod], :name => 'Tripod'
      scott_edgar = Act.make :performers => [scod], :name => 'Scott Edgar and the Universe'
      
      @slather    = Show.make :act => tripod, :name => 'Open Slather'
      @tosswinkle = Show.make :act => tripod, :name => 'Tosswinkle the Pirate'
      @universe   = Show.make :act => scott_edgar, :name => 'Scott Edgar and the Universe'
    end
    
    it "should return shows by the same act" do
      @slather.related.should include(@tosswinkle)
    end
    
    it "should return shows by any acts with the same performers" do
      @slather.related.should include(@universe)
    end
    
    it "should not include itself" do
      @slather.related.should_not include(@slather)
    end
  end
  
  describe '#scraped_time' do
    it "should return nil if there's no times provided" do
      Show.make.scraped_time(Date.new(2010, 3, 31), nil).should be_nil
    end
    
    it "should parse a standard time" do
      time = Show.make.scraped_time(Date.new(2010, 3, 31), "7pm")
      time.hour.should == 19
      time.min.should == 0
    end
    
    it "should handle times with minutes" do
      time = Show.make.scraped_time(Date.new(2010, 3, 31), "7.30pm")
      time.hour.should == 19
      time.min.should == 30
    end
    
    it "should handle times in the morning" do
      time = Show.make.scraped_time(Date.new(2010, 3, 31), "11am")
      time.hour.should == 11
      time.min.should == 0
      
      time = Show.make.scraped_time(Date.new(2010, 3, 31), "11.30am")
      time.hour.should == 11
      time.min.should == 30
    end
    
    it "should handle times with day ranges" do
      time = Show.make.scraped_time(
        Date.new(2010, 3, 31), "Tue-Sat 7pm, Sun 6pm"
      )
      time.hour.should == 19
      time.min.should == 0
      
      time = Show.make.scraped_time(
        Date.new(2010, 3, 28), "Tue-Sat 7pm, Sun 6pm"
      )
      time.hour.should == 18
      time.min.should == 0
    end
  end
end
