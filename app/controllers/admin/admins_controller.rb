class Admin::AdminsController < Admin::ApplicationController
  expose(:admins) { Admin.order('email') }
  expose(:admin)  { Admin.new }
  
  def invite
    Admin.invite! params[:admin]
    redirect_to :back
  end
end
