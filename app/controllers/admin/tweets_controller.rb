class Admin::TweetsController < ApplicationController
  include LaughTrack::CouchDb
  
  def unclassified
    @docs = db.function('_design/bayes/_view/unclassified')
  end
  
  def positive
    doc = db.get params[:id]
    doc.classification = 'positive'
    db.save doc
    
    redirect_to unclassified_admin_tweets_path
  end
  
  def negative
    doc = db.get params[:id]
    doc.classification = 'negative'
    db.save doc
    
    redirect_to unclassified_admin_tweets_path
  end
  
  def ignore
    doc = db.get params[:id]
    doc.ignore = true
    db.save doc
    
    redirect_to unclassified_admin_tweets_path
  end
end
