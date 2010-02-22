require 'open-uri'

module Importers
  class ComedyFestival
    URI_2008 = 'http://www.comedyfestival.com.au/season/2008/shows/a-z/'
    URI_2009 = 'http://www.comedyfestival.com.au/season/2009/shows/a-z/letter/'
    URI_2010 = 'http://www.comedyfestival.com.au/2010/season/shows/a-z/letter/'
    
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
    
    def self.import_2010
      ('a'..'z').each do |letter|
        import_2010_page URI_2010 + letter
      end
      
      import_2010_page URI_2010 + 'other'
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
    
    def self.import_2010_page(uri)
      html  = open(uri) { |stream| stream.read }
      doc   = Nokogiri::HTML html
      
      doc.css('.showList tbody tr').each do |row|
        link     = row.at('td').at('a')
        next if link.nil?
        
        act_name = link.at('.orange').text.strip.gsub(/[\s\-]+$/, '')
        name     = link.children[2].text.strip
        
        name, act_name = act_name, nil if name.blank?
        
        show = Show.find_by_name(name) || Show.new
        
        show.name     = name
        show.act_name = act_name
        show.status   = 'imported'
        show.save!
      end
      
      return unless doc.css('.showList tfoot .current').text.strip == '1'
      
      doc.css('.showList tfoot a').collect { |link|
        link['href']
      }.uniq.each do |paginated_uri|
        import_2010_page paginated_uri
      end
    end
  end
end
