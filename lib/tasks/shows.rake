namespace :shows do
  namespace :import do
    desc 'Import the 2010 shows from the Comedy Festival website'
    task '2010' => :environment do
      Importers::ComedyFestival.import_2010
    end
  end
  
  desc 'Log the show stats histories'
  task :histories => :environment do
    Show.write_histories
  end
end
