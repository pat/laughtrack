require 'spec_helper'

describe Admin::PerformersController do
  describe '#index' do
    before :each do
      Performer.stub!(:search => [])
      
      @action = lambda { get :index }
    end
    
    it_should_behave_like 'a private action'
    
    it "should assign the search results" do
      Performer.stub!(:search => [:foo, :bar])
      
      sign_in
      get :index
      
      assigns[:performers].should == [:foo, :bar]
    end
  end
  
  describe '#edit' do
    before :each do
      @performer = Performer.make
      @action = lambda { get :edit, :id => @performer.id }
    end
    
    it_should_behave_like 'a private action'
    
    it "should assign the performer" do
      sign_in
      get :edit, :id => @performer.id
      
      assigns[:performer].should == @performer
    end
  end
  
  describe '#update' do
    before :each do
      @performer = Performer.make
      Performer.stub!(:find => @performer)
      
      @action = lambda { put :update, :id => @performer.id, :performer => {} }
    end
    
    it_should_behave_like 'a private action'
    
    it "should redirect to the index on success" do
      @performer.stub!(:update_attributes => true)
      
      sign_in
      put :update, :id => @performer.id, :performer => {}
      
      response.should redirect_to(admin_performers_path)
    end
    
    it "should render the edit page on failure" do
      @performer.stub!(:update_attributes => false)
      
      sign_in
      put :update, :id => @performer.id, :performer => {}
      
      response.should render_template('admin/performers/edit')
    end
  end
end
