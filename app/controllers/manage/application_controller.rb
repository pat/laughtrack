class Manage::ApplicationController < ApplicationController
  before_filter :authenticate_user!

  private

  def set_layout
    'manage'
  end
end
