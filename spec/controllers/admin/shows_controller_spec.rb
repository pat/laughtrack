require 'spec/spec_helper'

describe Admin::ShowsController do
  describe '#index' do
    before :each do
      Show.stub!(:search => [])
      
      @action = lambda { get :index }
    end
    
    it_should_behave_like 'a private action'
    
    it "should assign the search results" do
      Show.stub!(:search => [:foo, :bar])
      
      sign_in_as_admin
      get :index
      
      assigns[:shows].should == [:foo, :bar]
    end
  end
  
  describe '#edit' do
    before :each do
      @show   = Show.make
      @action = lambda { get :edit, :id => @show.id }
    end
    
    it_should_behave_like 'a private action'
    
    it "should assign the requested show" do
      sign_in_as_admin
      get :edit, :id => @show.id
      
      assigns[:show].should == @show
    end
  end
  
  describe '#update' do
    before :each do
      @show = Show.make
      @show.stub!(:update_attributes => true)
      Show.stub!(:find => @show)
      
      @action = lambda { put :update, :id => @show.id, :show => {} }
    end
    
    it_should_behave_like 'a private action'
    
    it "should update the show" do
      @show.should_receive(:update_attributes)
      
      sign_in_as_admin
      put :update, :id => @show.id, :show => {}
    end
    
    it "should redirect to the index action" do
      sign_in_as_admin
      put :update, :id => @show.id, :show => {}
      
      response.should redirect_to(admin_shows_path)
    end
    
    it "should render the edit template on failure" do
      @show.stub!(:update_attributes => false)
      
      sign_in_as_admin
      put :update, :id => @show.id, :show => {}
      
      response.should render_template('edit')
    end
  end
end
