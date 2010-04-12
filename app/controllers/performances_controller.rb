class PerformancesController < ApplicationController
  def index
    @date = date
    @performances = Performance.for(date).ordered.available.find(:all, :include => [:show => [:act]], :order => "#{order} #{sort_mode}" ).paginate(
        :page      => params[:page]
    )
  end
  
  private
  
  def date
    return Date.today if [:year, :month, :date].all? { |key| params[key].blank?}
    
    Date.new params[:year].to_i, params[:month].to_i, params[:date].to_i
  end
  
  def sort_mode
    case params[:order]
    when 'asc'
      :asc
    when 'desc'
      :desc
    else
      nil
    end
  end
  
  def order
    case params[:sort_by]
    when 'act'
      'acts.name'
    when 'show'
      'shows.name'
    when 'sold_out'
      'shows.sold_out_percent'
    when 'rating'
      'shows.rating'
    else
      'happens_at'
    end
  end
end
