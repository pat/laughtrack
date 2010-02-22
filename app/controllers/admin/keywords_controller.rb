class Admin::KeywordsController < ApplicationController
  before_filter :authenticate
  
  def create
    show.keywords.create params[:keyword]
    
    redirect_to edit_admin_show_path(show)
  end
  
  def destroy
    show.keywords.find(params[:id]).destroy
    
    redirect_to edit_admin_show_path(show)
  end
  
  private
  
  def show
    @show ||= Show.find(params[:show_id])
  end
end
