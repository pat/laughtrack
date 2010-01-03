require 'open-uri'

module Importers
  class GroggySquirrel
    URI = 'http://www.thegroggysquirrel.com/atom'
    
    def self.import
      doc = Nokogiri::XML(open(URI))
      doc.css('entry').each do |entry|
        review = Review.find_by_source(entry.at('link')['href']) || Review.new
        
        review.name   = entry.at('title').text
        review.source = entry.at('link')['href']
        review.save
      end
    end
  end
end
