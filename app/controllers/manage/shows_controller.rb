class Manage::ShowsController < Manage::ApplicationController
  expose(:shows) { Show.order_by_headings }
end
