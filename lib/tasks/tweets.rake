namespace :tweets do
  task :import => :environment do
    Tweet.import!
  end
end
