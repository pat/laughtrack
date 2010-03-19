class Admin::ShowsController < Admin::ApplicationController
  include LaughTrack::CouchDb
  
  def index
    @shows = Show.search params[:query],
      :page      => params[:page],
      :include   => :act,
      :sort_mode => sort_mode,
      :order     => order
  end
  
  def edit
    @show = show
  end
  
  def update
    if show.update_attributes(params[:show])
      flash[:notice] = 'Changes saved.'
      redirect_to edit_admin_show_path(show)
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
  
  def clear_tweets
    show.tweets.select { |tweet|
      tweet.classification.nil?
    }.each { |tweet|
      tweet.ignore = true
      db.save tweet
    }
    
    redirect_to edit_admin_show_path(show)
  end
  
  private
  
  def show
    @show ||= Show.find params[:id]
  end
  
  def sort_mode
    case params[:order]
    when 'asc'
      :asc
    when 'desc'
      :desc
    else
      params[:query].blank? ? nil : :relevance
    end
  end
  
  def order
    if !params[:sort_by].blank?
      params[:sort_by].to_sym
    elsif params[:query].blank?
      :act
    else
      nil
    end
  end
end
