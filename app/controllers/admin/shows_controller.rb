class Admin::ShowsController < Admin::ApplicationController
  def index
    if params[:query].blank?
      @shows = Show.paginate :page => params[:page], :per_page => 20
    else
      @shows = Show.search params[:query], :page => params[:page]
    end
  end
  
  def edit
    @show = show
  end
  
  def update
    if show.update_attributes(params[:show])
      flash[:notice] = 'Changes saved.'
      redirect_to edit_admin_show_path(@show)
    else
      render :action => :edit
    end
  end
  
  def feature
    if show.random_tweet
      show.feature!
    else
      flash[:notice] = 'No tweets, so cannot feature.'
    end
    
    redirect_to :back
  end
  
  def unfeature
    show.unfeature!
    
    redirect_to :back
  end
  
  private
  
  def show
    @show ||= Show.find params[:id]
  end
end
