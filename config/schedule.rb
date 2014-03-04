# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
   set :environment, 'production'
 # set :output,'/home/Documents/cron_log/cron_log.log'
  # job_type :runner,  "cd :path && rails runner -e :development ':task' :output"
 # /home/sunil/.rvm/gems/ruby-1.9.3-p484/bin

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
every 1.day ,:at=>'04:15pm' do
   runner "Client.check_trail_duration"
end
every 1.day, :at => '12:01 am' do
  runner "Client.update_daily_bet_amount"
end

every 9.minutes do
  runner "Race.bet_reminder"
end
every 1.month do
  runner 'ClinetFee.calculate_fee'
end
# Learn more: http://github.com/javan/whenever
