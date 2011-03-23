desc 'Have cron index the Sphinx search indices'
task :cron => ['shows:import:2011', 'fs:index']
