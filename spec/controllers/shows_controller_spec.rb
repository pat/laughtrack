require 'spec/spec_helper'

describe ShowsController do
  describe '#index' do
    it "should assign the search results" do
      Show.stub!(:search => [:foo, :bar])
      
      get :index
      
      assigns[:shows].should == [:foo, :bar]
    end
    
    it "should use the given search parameters" do
      Show.should_receive(:search) do |query, options|
        query.should == 'foo'
      end
      
      get :index, :query => 'foo'
    end
    
    it "should sort by act by default" do
      Show.should_receive(:search) do |query, options|
        options[:order].should == :act
      end
      
      get :index
    end
    
    it "should sort by relevance if a query is provided" do
      Show.should_receive(:search) do |query, options|
        options[:sort_mode].should == :relevance
        options[:order].should be_nil
      end
      
      get :index, :query => 'foo'
    end
  end
  
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
