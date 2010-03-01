class Admin::PerformersController < Admin::ApplicationController
  def index
    @performers = Performer.search params[:query]
  end
  
  def edit
    @performer = Performer.find params[:id]
  end
  
  def update
    @performer = Performer.find params[:id]
    if @performer.update_attributes params[:performer]
      redirect_to admin_performers_path
    else
      render :action => 'edit'
    end
  end
end
