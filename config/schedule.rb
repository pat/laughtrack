# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# set :output, "/path/to/my/cron_log.log"

every 30.minutes do
  rake "twitter:cache thinking_sphinx:index"
end

every 1.day, :at => '12:15 am' do
  rake "shows:histories"
end

# Learn more: http://github.com/javan/whenever
