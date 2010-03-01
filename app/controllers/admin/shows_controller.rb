class Admin::ShowsController < Admin::ApplicationController
  def index
    @shows = Show.search params[:query]
  end
  
  def edit
    @show = Show.find params[:id]
  end
  
  def update
    @show = Show.find params[:id]
    
    if @show.update_attributes(params[:show])
      redirect_to admin_shows_path
    else
      render :action => :edit
    end
  end
end
