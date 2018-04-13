# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.minute do
  command "date > ~/cron-test.txt"
end

every 1.day, at: '5:00 am' do
  rake "-s sitemap:refresh"
end

every :reboot do
  command "cd /home/usabi/consul/current && RAILS_ENV=production bin/delayed_job start -n 2"
end

every 10.hours do
  command "cd /home/usabi/consul/current && RAILS_ENV=production bin/delayed_job restart -n 2"
end
