require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Performer do
  before(:each) do
    @attributes = {
      :name     => "Adam Hills",
      :country  => "Australia"
    }
  end
  
  it "should create a new instance given valid attributes" do
    Performer.new(@attributes).should be_valid
  end
  
  it "should be invalid without a name" do
    performer = Performer.new @attributes.except(:name)
    performer.should have(1).error_on(:name)
  end
end
