class AddAndSetShowLink < ActiveRecord::Migration
  def self.up
    add_column :shows, :url, :string
    
    Show.all.each do |show|
      slug = show.act_name + ' ' + show.name
      slug.strip!
      slug.gsub!('&', '')
      slug.gsub!(/[\s']+/, '-')
      slug.gsub!(/[^\w-]/, '')
      slug.downcase!
      show.url = "http://www.comedyfestival.com.au/2010/season/shows/#{slug}"
      show.save
    end
  end

  def self.down
    remove_column :shows, :url
  end
end


def missing?(url)
  RestClient.head(url)
  false
rescue
  true
end