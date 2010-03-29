namespace :shows do
  namespace :import do
    desc 'Import the 2010 shows from the Comedy Festival website'
    task '2010' => :environment do
      Importers::ComedyFestival.import_2010
    end
    
    desc 'Scrape performance dates and times from the MICF website'
    task :performances => :environment do
      Show.scrape_performances
    end
  end
end
