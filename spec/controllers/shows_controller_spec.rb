require 'spec/spec_helper'

describe ShowsController do
  describe '#show' do
    before :each do
      @show = Show.make
      @show.stub!(:related => [:foo, :bar])
      
      Show.stub!(:find => @show)
    end
    
    it "should assign the requested show" do
      get :show, :id => @show.id
      
      assigns[:show].should == @show
    end
    
    it "should assign the related shows from the requested show" do
      get :show, :id => @show.id
      
      assigns[:related].should == [:foo, :bar]
    end
  end
end
