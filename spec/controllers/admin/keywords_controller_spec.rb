require 'spec/spec_helper'

describe Admin::KeywordsController do
  describe '#create' do
    before :each do
      @show = Show.make
      @show.keywords.stub!(:create => nil)
      Show.stub!(:find => @show)
      
      @action = lambda { post :create, :show_id => @show.id, :keyword => {} }
    end

    it_should_behave_like 'a private action'
    
    it "should create the keyword" do
      @show.keywords.should_receive(:create)
      
      sign_in
      post :create, :show_id => @show.id, :keyword => {}
    end
    
    it "should redirect to the show's edit page" do
      sign_in
      post :create, :show_id => 1, :keyword => {}
      
      response.should redirect_to(edit_admin_show_path(@show))
    end
  end
  
  describe '#destroy' do
    before :each do
      @show    = Show.make
      @keyword = @show.keywords.make
      
      Show.stub!(:find => @show)
      Keyword.stub!(:find => @keyword)
      
      @action = lambda {
        get :destroy, :show_id => @show.id, :id => @keyword.id
      }
    end
    
    it_should_behave_like 'a private action'
    
    it "should destroy the given keyword" do
      @keyword.should_receive(:destroy)
      
      sign_in
      get :destroy, :show_id => @show.id, :id => @keyword.id
    end
    
    it "should redirect to the show's edit page" do
      sign_in
      get :destroy, :show_id => @show.id, :id => @keyword.id
      
      response.should redirect_to(edit_admin_show_path(@show))
    end
  end
end
