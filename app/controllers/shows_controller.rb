class ShowsController < ApplicationController
  # Add view helper modules so we can render pretty json
  include ApplicationHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TagHelper

  def index
    @title = case request.path
    when '/popular'
      'Popular Shows'
    when '/quality'
      'Quality Shows'
    else
      'All Shows'
    end
    
    @shows = festival.shows.search params[:query],
      :page      => params[:page],
      :include   => :act,
      :sort_mode => sort_mode,
      :order     => order,
      :without   => {:performance_count => 0}
  end
  
  def show
    @show    = festival.shows.find params[:id]
    @title   = @show.name
    @related = @show.related if @show.act
  end
  
  def tweets
    @show    = festival.shows.find params[:id]
    respond_to do |format|
      format.json { 
        render :json => @show.tweets.confirmed.order('created_at DESC').collect { |tweet|
          tweet.text            = twitify(tweet.text)
          tweet.created_at_to_s = time_ago_in_words(tweet.created_at)
          tweet
        }.to_json
      }
    end
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
