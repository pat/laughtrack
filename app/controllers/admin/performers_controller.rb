class Admin::PerformersController < Admin::ApplicationController
  expose(:performers) { Performer.search params[:query] }
  expose(:performer)  { Performer.find params[:id] }
  
  def index
    #
  end
  
  def edit
    #
  end
  
  def update
    if performer.update_attributes params[:performer]
      redirect_to admin_performers_path
    else
      render :action => 'edit'
    end
  end
end
