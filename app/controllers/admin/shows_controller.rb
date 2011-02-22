class Admin::ShowsController < Admin::ApplicationController
  include LaughTrack::CouchDb
  
  expose(:shows) {
    Show.search params[:query],
      :page      => params[:page],
      :include   => :act,
      :sort_mode => sort_mode,
      :order     => order
  }
  expose(:show) { Show.find params[:id] }
  
  def index
    #
  end
  
  def edit
    #
  end
  
  def update
    if show.update_attributes(params[:show])
      flash[:notice] = 'Changes saved.'
      redirect_to [:edit, :admin, show]
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
    show.unconfirmed_tweets.each { |tweet|
      tweet.ignore = true
      db.save tweet
    }
    show.update_tweet_count
    show.save
    
    redirect_to edit_admin_show_path(show)
  end
  
  def import_tweet
    LaughTrack::Tweet.import params[:url], params[:id].to_i
    
    redirect_to :back
  end
  
  private
  
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
