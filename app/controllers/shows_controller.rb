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
    params[:query].blank? ? nil : :relevance
  end
  
  def order
    params[:query].blank? ? :act : nil
  end
end
