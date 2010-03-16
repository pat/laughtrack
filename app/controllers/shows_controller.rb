class ShowsController < ApplicationController
  def index
    @shows = Show.search params[:query],
      :page      => params[:page],
      :include   => :act,
      :sort_mode => sort_mode,
      :order     => order
  end
  
  def show
    @show    = Show.find params[:id]
    @related = @show.related if @show.act
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
