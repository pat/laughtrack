require 'spec_helper'

describe Admin::PerformersController do
  describe '#index' do
    let(:action) { get :index }
    
    before :each do
      Performer.stub!(:search => [])
    end
    
    it_is_a_private_action
  end
  
  describe '#edit' do
    let(:performer) { Performer.make! }
    let(:action)    { get :edit, :id => performer.id }
    
    it_is_a_private_action    
  end
  
  describe '#update' do
    let(:performer) { Performer.make! }
    let(:action)    { put :update, :id => performer.id, :performer => {} }
    
    before :each do
      Performer.stub!(:find => performer)
    end
    
    it_is_a_private_action
    
    it "should redirect to the index on success" do
      performer.stub!(:update_attributes => true)
      
      sign_in_as_admin
      put :update, :id => performer.id, :performer => {}
      
      response.should redirect_to(admin_performers_path)
    end
    
    it "should render the edit page on failure" do
      performer.stub!(:update_attributes => false)
      
      sign_in_as_admin
      put :update, :id => performer.id, :performer => {}
      
      response.should render_template('admin/performers/edit')
    end
  end
end
