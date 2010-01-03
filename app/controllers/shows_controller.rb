class ShowsController < ApplicationController
  def show
    @show    = Show.find params[:id]
    @related = @show.related
  end
end
