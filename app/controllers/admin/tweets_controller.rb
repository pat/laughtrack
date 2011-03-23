class Admin::TweetsController < Admin::ApplicationController
  expose(:tweet) { Tweet.find params[:id] }
  
  def unclassified
    @total  = Tweet.unconfirmed.count
    @tweets = Tweet.unclassified.limit(20)
  end
  
  def unconfirmed
    @docs = Tweet.unconfirmed.limit(20)
  end
  
  def confirmed
    @docs = Tweet.confirmed
  end
  
  def positive
    tweet.update_attributes(
      :classification => 'positive',
      :confirmed      => true
    )
    
    redirect_to :back
  end
  
  def negative
    tweet.update_attributes(
      :classification => 'negative',
      :confirmed      => true
    )
    
    redirect_to :back
  end
  
  def ignore
    tweet.update_attributes :ignore => true
    
    redirect_to :back
  end
  
  def confirm
    tweet.update_attributes :confirmed => true
    
    redirect_to :back
  end
end
