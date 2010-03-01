require 'spec_helper'

describe Admin::PerformancesController do
  describe '#create' do
    before :each do
      @show = Show.make
      @show.performances.stub!(:create => true)
      Show.stub!(:find => @show)
      
      @action = lambda {
        post :create, :show_id => @show.id, :performance => {}
      }
    end
    
    it_should_behave_like 'a private action'
    
    it "should redirect to the show's edit page on success" do
      sign_in_as_admin
      post :create, :show_id => @show.id, :performance => {}
      
      response.should redirect_to(edit_admin_show_path(@show))
    end
    
    it "should render the show's edit page on failure" do
      @show.performances.stub!(:create => false)
      sign_in_as_admin
      post :create, :show_id => @show.id, :performance => {}
      
      response.should render_template('admin/performances/../shows/edit')
    end
  end
  
  describe '#sold_out' do
    before :each do
      @show         = Show.make
      @performance  = @show.performances.make
      Show.stub!(:find => @show)
      
      @action = lambda {
        get :sold_out, :show_id => @show.id, :id => @performance.id
      }
    end
    
    it_should_behave_like 'a private action'
    
    it "should mark the performance as sold out" do
      sign_in_as_admin
      get :sold_out, :show_id => @show.id, :id => @performance.id
      
      @performance.reload
      @performance.sold_out.should be_true
    end
    
    it "should redirect to the show's edit page" do
      sign_in_as_admin
      get :sold_out, :show_id => @show.id, :id => @performance.id
      
      response.should redirect_to(edit_admin_show_path(@show))
    end
  end
  
  describe '#available' do
    before :each do
      @show         = Show.make
      @performance  = @show.performances.make :sold_out => true
      Show.stub!(:find => @show)
      
      @action = lambda {
        get :available, :show_id => @show.id, :id => @performance.id
      }
    end
    
    it_should_behave_like 'a private action'
    
    it "should mark the performance as sold out" do
      sign_in_as_admin
      get :available, :show_id => @show.id, :id => @performance.id
      
      @performance.reload
      @performance.sold_out.should be_false
    end
    
    it "should redirect to the show's edit page" do
      sign_in_as_admin
      get :available, :show_id => @show.id, :id => @performance.id
      
      response.should redirect_to(edit_admin_show_path(@show))
    end
  end
end
