desc 'Have cron index the Sphinx search indices'
task :cron => 'fs:index'
