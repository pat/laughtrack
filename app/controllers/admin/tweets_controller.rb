class Admin::TweetsController < Admin::ApplicationController
  include LaughTrack::CouchDb
  
  def unclassified
    @total = db.function('_design/laughtrack/_view/unclassified').length
    @docs = unclassified_ids.collect { |hash| db.get hash.id }
  end
  
  def unconfirmed
    @docs = unconfirmed_ids.collect { |hash| db.get hash.id }
  end
  
  def confirmed
    @docs = confirmed_ids.collect { |hash| db.get hash.id }
  end
  
  def positive
    doc = db.get params[:id]
    doc.classification = 'positive'
    doc.confirmed      = true
    db.save doc
    
    redirect_to :back
  end
  
  def negative
    doc = db.get params[:id]
    doc.classification = 'negative'
    doc.confirmed      = true
    db.save doc
    
    redirect_to :back
  end
  
  def ignore
    doc = db.get params[:id]
    doc.ignore = true
    db.save doc
    
    redirect_to :back
  end
  
  def confirm
    doc = db.get params[:id]
    doc.confirmed = true
    db.save doc
    
    redirect_to :back
  end
  
  private
  
  def unclassified_ids
    @unclassified_ids ||= db.function('_design/laughtrack/_view/unclassified',
      :limit => 20)
  end
  
  def unconfirmed_ids
    @unconfirmed_ids ||= db.function('_design/laughtrack/_view/unconfirmed',
      :limit => 20)
  end
  
  def confirmed_ids
    @confirmed_ids ||= db.function('_design/laughtrack/_view/confirmed')
  end
end
