namespace :keywords do
  desc 'Import 60 keywords from Twitter'
  task :import => :environment do
    Keyword.import_oldest
  end
end
