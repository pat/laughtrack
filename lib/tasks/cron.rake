desc 'Have cron index the Sphinx search indices'
task :cron => ['shows:import:2011', 'twitter:import', 'twitter:cache', 'fs:index'] do
  if Time.zone.now.hour == 0
    Show.write_histories
  end
end
