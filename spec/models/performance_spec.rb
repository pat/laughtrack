require 'spec_helper'

describe Performance do
  describe '#valid?' do
    it "should be invalid without a show" do
      performance = Performance.make :show => nil
      performance.should have(1).error_on(:show)
    end
    
    it "should be invalid without a date" do
      performance = Performance.make :happens_at => nil
      performance.should have(1).error_on(:happens_at)
    end
  end
  
  describe '#save' do
    let(:show) { Show.make! }
    
    it "should update the show's sold out percentage" do
      performance = Performance.make! :show => show
      show.reload
      show.sold_out_percent.should == 0.0
      
      performance.sold_out = true
      performance.save
      
      show.reload
      show.sold_out_percent.to_f.should == 100.0
    end
    
    it "should track states of other performances of the same show" do
      performance = Performance.make! :show => show
      Performance.make! :show => show
      
      performance.sold_out = true
      performance.save
      
      show.reload
      show.sold_out_percent.to_f.should == 50.0
    end
  end
  
  describe '#sold_out!' do
    before :each do
      @performance = Performance.make :sold_out => false
    end
    
    it "should set the sold_out flag" do
      @performance.sold_out!
      @performance.sold_out.should be_true
    end
    
    it "should save the object" do
      @performance.sold_out!
      @performance.should_not be_a_new_record
    end
  end
  
  describe '#available!' do
    before :each do
      @performance = Performance.make :sold_out => true
    end
    
    it "should set the sold_out flag" do
      @performance.available!
      @performance.sold_out.should be_false
    end
    
    it "should save the object" do
      @performance.available!
      @performance.should_not be_a_new_record
    end
  end
end
