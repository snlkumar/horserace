# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 set :output, "home/Documents/cron_log/cron_log.log"
 # job_type :runner,  "cd :path && rails runner -e :development ':task' :output"
 set :job_template, "/bin/bash -i -c ':job'"
 
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
every 1.minute do
  runner "User.check_trail_duration"
end

# every 9.minutes do
  # runner "Race.bet_reminder"
# end
# Learn more: http://github.com/javan/whenever
