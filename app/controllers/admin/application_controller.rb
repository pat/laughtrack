class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
end
