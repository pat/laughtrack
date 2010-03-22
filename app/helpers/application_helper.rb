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
  
  def show_attributes(show)
    {
      :class => show.featured? ? 'featured' : nil
    }
  end
  
  def order_params(attribute)
    {
      :sort_by => attribute,
      :order   => order_direction(attribute)
    }
  end
  
  def order_direction(attribute)
    if params[:sort_by] == attribute
      params[:order] == 'asc' ? 'desc' : 'asc'
    elsif ['sold_out_percent', 'rating', 'unconfirmed_tweet_count'].include? attribute
      'desc'
    else
      'asc'
    end
  end
  
  def twitify(text)
    auto_link text.
      gsub(/@(\w+)/, %Q{<a href="http://twitter.com/\\1" class="twitter_name" target="_blank">@\\1</a>}).
      gsub(/#(\w+)/, %Q{<a href="http://search.twitter.com/search?q=\\1" class="twitter_hash" target="_blank">#\\1</a>})
  end
  
  def tweet_link(tweet)
    "http://twitter.com/#{tweet.from_user}/status/#{tweet.id.to_i}"
  end
  
end
