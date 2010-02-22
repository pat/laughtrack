class LaughTrack::Twitter
  extend LaughTrack::CouchDb
  
  def self.process
    view = '_design/laughtrack/_view/unprocessed'
    
    db.function(view).each do |record|
      doc = db.get record.id
      
      doc.sanitised_text = Pedantic.fix doc.text
      doc.processed      = true
      doc.ignore         = true if doc.text[/^RT\s/i]
      
      db.save doc
    end
  end
end
