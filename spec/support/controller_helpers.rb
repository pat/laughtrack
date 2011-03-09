module ControllerHelpers
  def self.included(base)
    base.instance_eval do
      extend ControllerHelpers::ClassMethods
    end
  end
  
  module ClassMethods
    def it_is_a_private_action
      it "should not be publicly accessible" do
        action
        
        response.should redirect_to(new_admin_session_path)
      end
      
      it "should not be accessible if logged in as a normal user" do
        sign_in User.make!
        action
        
        response.should redirect_to(new_admin_session_path)
      end
      
      it "should be accessible if logged in as an administrator" do
        sign_in Admin.make!
        action
        
        response.should_not redirect_to(new_admin_session_path)
      end
    end
  end
  
  def sign_in_as_admin(admin = Admin.make!)
    sign_in admin
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers,   :type => :controller
  config.include Devise::TestHelpers, :type => :controller
end
