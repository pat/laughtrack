describe 'a private action', :shared => true do
  it "should not be publicly accessible" do
    @action.call
    
    response.should redirect_to(new_session_url)
  end

  it "should be accessible if logged in" do
    sign_in User.make
    @action.call
    
    response.should_not redirect_to(new_session_url)
  end
end