require 'spec/spec_helper'

describe HomeController do
  describe '#index' do
    before :each do
      @popular = stub('popular')
      @popular.stub!(:limited => @popular)
      
      @rated = stub('rated')
      @rated.stub!(:limited => @rated)
      
      Show.stub!(:popular => @popular, :rated => @rated)
    end
    
    it "should set the popular shows" do
      get :index
      
      assigns[:popular].should == @popular
    end
    
    it "should limit the number of popular shows" do
      @popular.should_receive(:limited)
      
      get :index
    end
    
    it "should set the highly rated shows" do
      get :index
      
      assigns[:rated].should == @rated
    end
    
    it "should limit the number of rated shows" do
      @rated.should_receive(:limited)
      
      get :index
    end
  end
end
