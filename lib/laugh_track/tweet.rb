require 'open-uri'

class LaughTrack::Tweet
  extend LaughTrack::CouchDb
  
  def self.import(url, show_id)
    match = url.match /\/(\w+)\/status\/(\d+)/
    user  = match[1]
    id    = match[2].to_i
    
    api = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{user}"
    tweet = JSON.load(open(api)).detect { |hash|
      hash['id'] == id
    }
    
    return if tweet.nil?
    
    db.save tweet.merge(
      :show_id           => show_id,
      :profile_image_url => tweet['user']['profile_image_url'],
      :from_user         => user
    )
  end
end
