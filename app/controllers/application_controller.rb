# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # include Clearance::Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  private
  
  def admin?
    redirect_to new_user_session_path unless current_user && current_user.admin?
  end
  
  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    else
      render_500
    end
  end
  
  def render_404
    render :template => '/home/four_oh_four', :status => 404
  end
  
  def render_500
    render :template => '/home/five_hundred', :status => 500
  end
end
