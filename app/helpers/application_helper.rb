# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    if @title.nil?
      "LaughTrack"
    else
      "#{@title} - LaughTrack"
    end
  end
  
  def link_to_show(show, options = {})
    show_id, show = show, Show.find(show) if show.is_a?(Fixnum)
    link_to heading_for_show(show, options), show
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
    "http://twitter.com/#{tweet.from_user}/status/#{tweet.tweet_id}"
  end
  
  def sorted_header(label, key, default = false)
    content_tag :th, link_to(label, order_params(key)),
      :class => sorted_class(key, default)
  end
  
  def sorted_class(key, default)
    if params['sort_by'].blank? && default
      'sorted'
    elsif params['sort_by'] == key
      'sorted'
    else
      ''
    end
  end
  
  def show_url(show)
    if show.url.blank?
      nil
    else
      link_to('View', show.url)
    end
  end
  
  private
  
  def heading_for_show(show, options = {})
    if show.heading_two.blank?
      show.heading_one
    elsif options[:full]
      show.headings
    else
      show.heading_two
    end
  end
end
