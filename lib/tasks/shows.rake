namespace :shows do
  namespace :import do
    desc 'Import the 2011 shows from the Comedy Festival website'
    task '2011' => :environment do
      importer = Importers::FestivalTwo
      importer.download and importer.import
    end
    
    desc 'Import the 2010 shows from the Comedy Festival website'
    task '2010' => :environment do
      Importers::ComedyFestival.import_2010
    end
    
    desc 'Scrape performance dates and times from the MICF website'
    task :performances => :environment do
      Show.scrape_performances
    end
    
    desc 'Validate performance dates'
    task :validate => :environment do
      Show.validate_performances
    end
  end
  
  desc 'Log the show stats histories'
  task :histories => :environment do
    Show.write_histories
  end
end
