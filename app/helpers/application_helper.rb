module ApplicationHelper
  def alert_message(msg, type='success')
    content_tag(:div, :class => "alert alert-#{type}") do
      content_tag(:a, 'x', :class => 'close', :'data-dismiss' => 'alert') +
      content_tag(:p, msg)
    end
  end
end
