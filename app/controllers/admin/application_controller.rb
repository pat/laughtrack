class Admin::ApplicationController < ApplicationController
  before_filter :authenticate
  before_filter :admin?
end
