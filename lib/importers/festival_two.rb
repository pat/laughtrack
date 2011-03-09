require 'open-uri'
require 'zlib'

module Importers
  class FestivalTwo
    def download
      open(db_path, 'w') { |f|
        zip = Zlib::GzipReader.new StringIO.new(gzipped_db)
        f.write zip.read
      }
    end
    
    def import
      db.execute(shows_sql) do |show_row|
        show = festival.shows.where(:micf_id => show_row[5]).first
        show ||= festival.shows.build
        show.attributes = {
          :heading_one => show_row[2],
          :heading_two => show_row[3],
          :micf_id     => show_row[5]
        }
        show.name     = show_row[0]   if show.name.blank?
        show.name     = show.act_name if show.name.blank?
        show.act_name = show_row[1]   if show.act_name.blank?
        show.url      = show_row[4]   if show.url.blank?
        show.save!
      end
      
      festival.shows.reload
      festival.shows.each do |show|
        db.execute(performances_sql(show.micf_id)) do |perf_row|
          happens_at = Time.zone.at(perf_row[0]) + 31.years + 1.day
          if show.performances.where(:happens_at => happens_at).count == 0
            show.performances.create(
              :happens_at => happens_at,
              :sold_out   => perf_row[1]
            )
          end
        end
      end
    end
    
    private
    
    def gzipped_db
      open('http://122.248.253.122/comedysql.php').read
    end
    
    def db
      @db ||= SQLite3::Database.new db_path
    end
    
    def db_path
      File.join Rails.root, "tmp/2011.db"
    end
    
    def festival
      @festival ||= Festival.latest.first
    end
    
    def festival_url_base
      'http://www.comedyfestival.com.au/2011/season/shows/'
    end
    
    def shows_sql
      <<-SQL
SELECT ZHEADING_2 AS name,
  ZHEADING_1 AS act_name,
  ZHEADING_1 AS heading_one,
  ZHEADING_2 AS heading_two,
  '#{festival_url_base}' || CAST(zid as varchar) as url,
  ZID as micf_id
FROM ZCOMEDYENTITY
ORDER BY ZID
      SQL
    end
    
    def performances_sql(micf_id)
      <<-SQL
SELECT zd.ZDATE AS happens_at, zd.ZSOLDOUT as sold_out
FROM ZCOMEDYENTITY zc
  INNER JOIN ZDATESENTITY zd ON zd.ZPARENT = zc.Z_PK
WHERE zc.ZID = #{micf_id}
ORDER BY zd.ZDATE
      SQL
    end
  end
end
