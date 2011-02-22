require 'spec_helper'

describe Admin::KeywordsController do
  describe '#create' do
    let(:show)   { Show.make! }
    let(:action) { post :create, :show_id => show.id, :keyword => {} }
    
    before :each do
      show.keywords.stub!(:create => nil)
      Show.stub!(:find => show)
    end

    it_is_a_private_action
    
    it "should create the keyword" do
      show.keywords.should_receive(:create)
      
      sign_in_as_admin
      post :create, :show_id => show.id, :keyword => {}
    end
    
    it "should redirect to the show's edit page" do
      sign_in_as_admin
      post :create, :show_id => 1, :keyword => {}
      
      response.should redirect_to(edit_admin_show_path(show))
    end
  end
  
  describe '#destroy' do
    let(:show)    { Show.make! }
    let(:keyword) { show.keywords.make! }
    let(:action)  { get :destroy, :show_id => show.id, :id => keyword.id }
    
    before :each do
      Show.stub!(:find => show)
      show.keywords.stub!(:find => keyword)
    end
    
    it_is_a_private_action
    
    it "should destroy the given keyword" do
      keyword.should_receive(:destroy)
      
      sign_in_as_admin
      get :destroy, :show_id => show.id, :id => keyword.id
    end
    
    it "should redirect to the show's edit page" do
      sign_in_as_admin
      get :destroy, :show_id => show.id, :id => keyword.id
      
      response.should redirect_to(edit_admin_show_path(show))
    end
  end
end
