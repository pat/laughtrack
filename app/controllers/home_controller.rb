class HomeController < ApplicationController
  expose(:shows) { Show.order_by_headings }
end
