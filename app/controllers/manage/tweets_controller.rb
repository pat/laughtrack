class Manage::TweetsController < Manage::ApplicationController
  expose(:pending_tweets)      { Tweet.pending }
  expose(:unclassified_tweets) { Tweet.unclassified }
  expose(:detached_tweets)     { Tweet.detached }

  def bulk_update
    params.keys.collect { |key|
      key[/^action_(\d+)$/, 1]
    }.compact.reject { |id|
      params["action_#{id}"] == 'wait'
    }.each { |id|
      tweet = Tweet.find(id)
      value = params["action_#{id}"]

      case value
      when 'ignore'
        tweet.ignore!
      when 'keep'
        tweet.confirm!
      when 'positive'
        tweet.positive!
      when 'negative'
        tweet.negative!
      else
        raise "Unknown bulk update action: #{value}"
      end
    }

    redirect_to :back
  end

  def attach
    Tweet.find(params[:id]).attach_to params[:tweet][:show_id]

    redirect_to :back
  end
end
