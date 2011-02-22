require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Review do
  before(:each) do
    @attributes = {
      :show   => Show.make!,
      :rating => 3.5,
      :name   => "Review of a Show",
      :source => "The Age"
    }
  end

  it "should create a new instance given valid attributes" do
    Review.new(@attributes).should be_valid
  end
  
  it "should be invalid without a name" do
    review = Review.new @attributes.except(:name)
    review.should have(1).error_on(:name)
  end
end
