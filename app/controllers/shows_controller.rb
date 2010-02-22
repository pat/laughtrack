class ShowsController < ApplicationController
  def index
    @shows = Show.search params[:query],
      :page    => params[:page],
      :include => :act
  end
  
  def show
    @show    = Show.find params[:id]
    @related = @show.related if @show.act
  end
end
