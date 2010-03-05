class Admin::TweetsController < Admin::ApplicationController
  include LaughTrack::CouchDb
  
  def unclassified
    @docs = unclassified_ids.collect { |hash|
      db.get hash.id
    }
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
  
  private
  
  def unclassified_ids
    @unclassified_ids ||= db.function('_design/laughtrack/_view/unclassified',
      :limit => 20)
  end
end
