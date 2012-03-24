class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :set_layout

  private

  def pjax?
    request.headers['X-PJAX']
  end

  def set_layout
    !pjax? && 'application'
  end
end
