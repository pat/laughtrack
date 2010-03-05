# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_show(show)
    show_id, show = show, Show.find(show) if show.is_a?(Fixnum)
    link_to(show.name, show)
  end
  
  def act_name(act)
    act ? act.name : ''
  end
  
  def performance_sold_out_link(performance)
    if performance.sold_out
      link_to 'Not Sold Out',
        [:available, :admin, performance.show, performance]
    else
      link_to 'Sold Out', [:sold_out, :admin, performance.show, performance]
    end
  end
end
