class Admin::PerformancesController < Admin::ApplicationController
  expose(:show)        { Show.find params[:show_id] }
  expose(:performance) {
    if params[:id]
      show.performances.find params[:id]
    else
      show.performances.build params[:performance]
    end
  }
  
  def create
    if performance.save
      redirect_to [:edit, :admin, show]
    else
      render :template => 'admin/shows/edit'
    end
  end
  
  def sold_out
    performance.sold_out!
    
    redirect_to [:edit, :admin, show]
  end
  
  def available
    performance.available!
    
    redirect_to [:edit, :admin, show]
  end
  
  def destroy
    performance.destroy
    
    redirect_to :back
  end
end
