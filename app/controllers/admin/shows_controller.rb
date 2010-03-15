class Admin::ShowsController < Admin::ApplicationController
  def index
    @shows = Show.search params[:query], :page => params[:page]
  end
  
  def edit
    @show = Show.find params[:id]
  end
  
  def update
    @show = Show.find params[:id]
    
    if @show.update_attributes(params[:show])
      flash[:notice] = 'Changes saved.'
      redirect_to edit_admin_show_path(@show)
    else
      render :action => :edit
    end
  end
end
