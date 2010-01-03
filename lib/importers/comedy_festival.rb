require 'open-uri'

module Importers
  class ComedyFestival
    URI_2008 = 'http://www.comedyfestival.com.au/season/2008/shows/a-z/'
    URI_2009 = 'http://www.comedyfestival.com.au/season/2009/shows/a-z/letter/'
    
    def self.import
      import_2008
      import_2009
    end
    
    def self.import_2008
      ('a'..'z').each do |letter|
        import_page URI_2008 + letter
      end
      
      import_page URI_2008 + 'other'
    end
    
    def self.import_2009
      ('a'..'z').each do |letter|
        import_page URI_2009 + letter
      end
      
      import_page URI_2009 + 'other'
    end
    
    def self.import_page(uri)
      html  = open(uri) { |stream| stream.read }
      doc   = Nokogiri::HTML html
      
      doc.css('.azTable tr.even, .azTable tr.odd').each do |row|
        name = row.at('td').at('a').text
        show = Show.find_by_name(name) || Show.new
    
        show.name   = name
        show.status = 'imported'
        show.save!
      end
    end
  end
end
