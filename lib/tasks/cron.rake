desc 'Have cron index the Sphinx search indices'
task :cron => ['twitter:import', 'twitter:cache', 'fs:index'] do
  if Time.zone.now.hour == 0
    Show.write_histories
  end
end
