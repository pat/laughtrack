class PerformancesController < ApplicationController
  def index
    @performances = Performance.for(date).ordered.available.paginate(
      :page => params[:page]
    )
  end
  
  private
  
  def date
    return Date.today if [:year, :month, :date].all? { |key| params[key].blank?}
    
    Date.new params[:year].to_i, params[:month].to_i, params[:date].to_i
  end
end
