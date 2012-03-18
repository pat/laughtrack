namespace :shows do
  task :import => :environment do
    Show.import!
  end
end
