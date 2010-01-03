class Admin::PerformancesController < ApplicationController
  before_filter :authenticate
  
  def create
    if show.performances.create params[:performance]
      redirect_to edit_admin_show_path(show)
    else
      render :action => '../shows/edit'
    end
  end
  
  def sold_out
    performance.sold_out!
    
    redirect_to edit_admin_show_path(show)
  end
  
  def available
    performance.available!
    
    redirect_to edit_admin_show_path(show)
  end
  
  private
  
  def show
    @show ||= Show.find params[:show_id]
  end
  
  def performance
    @performance ||= show.performances.find params[:id]
  end
end
