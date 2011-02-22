require 'spec_helper'

describe Admin::ShowsController do
  describe '#index' do
    let(:action) { get :index }
    
    before :each do
      Show.stub!(:search => [])
    end
    
    it_is_a_private_action
  end
  
  describe '#edit' do
    let(:show)   { Show.make! }
    let(:action) { get :edit, :id => show.id }
    
    it_is_a_private_action
  end
  
  describe '#update' do
    let(:show)   { Show.make! }
    let(:action) { put :update, :id => show.id, :show => {} }
    
    before :each do
      show.stub!(:update_attributes => true)
      Show.stub!(:find => show)
    end
    
    it_is_a_private_action
    
    it "should update the show" do
      show.should_receive(:update_attributes)
      
      sign_in_as_admin
      put :update, :id => show.id, :show => {}
    end
    
    it "should redirect to the index action" do
      sign_in_as_admin
      put :update, :id => show.id, :show => {}
      
      response.should redirect_to(edit_admin_show_path(show))
    end
    
    it "should render the edit template on failure" do
      show.stub!(:update_attributes => false)
      
      sign_in_as_admin
      put :update, :id => show.id, :show => {}
      
      response.should render_template('edit')
    end
  end
end
