require 'spec_helper'

describe Admin::PerformancesController do
  describe '#create' do
    let(:show)   { Show.make! }
    let(:action) { post :create, :show_id => show.id, :performance => {} }
    
    before :each do
      show.performances.stub! :build => stub('performance', :save => true)
      Show.stub!(:find => show)
    end
    
    it_is_a_private_action
    
    it "should redirect to the show's edit page on success" do
      sign_in_as_admin
      
      post :create, :show_id => show.id, :performance => {}
      
      response.should redirect_to(edit_admin_show_path(show))
    end
    
    it "should render the show's edit page on failure" do
      show.performances.stub! :build => stub('performance', :save => false)
      sign_in_as_admin
      
      post :create, :show_id => show.id, :performance => {}
      
      response.should render_template('admin/shows/edit')
    end
  end
  
  describe '#sold_out' do
    let(:show)        { Show.make! }
    let(:performance) { Performance.make! :show => show }
    let(:action)      {
      get :sold_out, :show_id => show.id, :id => performance.id
    }
    
    before :each do
      Show.stub!(:find => show)
    end
    
    it_is_a_private_action
    
    it "should mark the performance as sold out" do
      sign_in_as_admin
      
      get :sold_out, :show_id => show.id, :id => performance.id
      
      performance.reload
      performance.sold_out.should be_true
    end
    
    it "should redirect to the show's edit page" do
      sign_in_as_admin
      get :sold_out, :show_id => show.id, :id => performance.id
      
      response.should redirect_to(edit_admin_show_path(show))
    end
  end
  
  describe '#available' do
    let(:show)        { Show.make! }
    let(:performance) { Performance.make! :sold_out => true, :show => show }
    let(:action)      {
      get :available, :show_id => show.id, :id => performance.id
    }
    
    before :each do
      Show.stub!(:find => show)
    end
    
    it_is_a_private_action
    
    it "should mark the performance as sold out" do
      sign_in_as_admin
      
      get :available, :show_id => show.id, :id => performance.id
      
      performance.reload
      performance.sold_out.should be_false
    end
    
    it "should redirect to the show's edit page" do
      sign_in_as_admin
      
      get :available, :show_id => show.id, :id => performance.id
      
      response.should redirect_to(edit_admin_show_path(show))
    end
  end
end
