namespace :twitter do
  desc 'Import 60 keywords from Twitter'
  task :import => :environment do
    Keyword.import_oldest
  end
  
  desc 'Run unprocessed tweets through Pedantic'
  task :process => :environment do
    LaughTrack::Twitter.process
  end
end
