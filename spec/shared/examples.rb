describe 'a private action', :shared => true do
  it "should not be publicly accessible" do
    @action.call
    
    response.should redirect_to(new_session_url)
  end
  
  it "should not be accessible if logged in as a normal user" do
    sign_in User.make
    @action.call
    
    response.should redirect_to(new_session_url)
  end
  
  it "should be accessible if logged in as an administrator" do
    sign_in User.make(:admin)
    @action.call
    
    response.should_not redirect_to(new_session_url)
  end
end
