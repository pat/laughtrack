class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_admin!
  
  layout 'admin'
end
