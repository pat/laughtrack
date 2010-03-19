class LaughTrack::Twitter
  extend LaughTrack::CouchDb
  
  def self.process
    view   = '_design/laughtrack/_view/unprocessed'
    update = db.url + '/_design/laughtrack/_update/calculate_classification'
    
    db.function(view).each do |record|
      doc = db.get record.id
      
      doc.sanitised_text = Pedantic.fix doc.text
      doc.processed      = true
      doc.ignore         = ignore?(doc.text)
      
      scores = {:positive => 0, :negative => 0}
      scores.keys.each do |key|
        total = db.function("_design/laughtrack/_view/#{key}").first.value
        words = db.function "_design/laughtrack/_view/#{key}", :group_level => 1
        
        doc.sanitised_text.split(/w+/).each do |word|
          match  = words.detect { |w| w.key == word }
          factor = match.nil? ? 0.1 : match.value
          
          scores[key] += Math.log(factor / total)
        end
      end
      
      doc.classification = scores.sort_by { |a| -a[1] }.first.first.to_s
      
      db.save doc
    end
  end
  
  def self.ignore?(text)
    case text
    when /^RT /i
    when /I favorited a YouTube video/
      true
    else
      false
    end
  end
end
