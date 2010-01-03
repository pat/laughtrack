require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Act do
  describe 'validations' do
    it "should create a new instance given valid attributes" do
      Act.make_unsaved.should be_valid
    end
    
    it "should be invalid without a name" do
      act = Act.make_unsaved :name => nil
      act.should have(1).error_on(:name)
    end    
  end
  
  describe '#status' do
    it "should default to 'confirmed'" do
      Act.new.status.should == 'confirmed'
    end
  end
  
  describe '#performers' do
    it "should be set with a performer of the same name as the act by default" do
      act = Act.make :performers => []
      act.performers.first.name.should == act.name
    end
  end
end
