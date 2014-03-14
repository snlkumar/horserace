require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.new
scheduler.every("10m") do
   Race.bet_reminder
end
# scheduler.every 1.day ,:at=>'04:15pm' do
   # runner "Client.check_trail_duration"
# end
scheduler.cron '15 16 * * *' do
  Client.update_daily_bet_amount
end
scheduler.cron '1 0 * * *' do
  Client.update_daily_bet_amount
end
# scheduler.every 1.day, :at => '12:01 am' do
  # runner "Client.update_daily_bet_amount"
# end

# scheduler.every 9.minutes do
  # runner "Race.bet_reminder"
# end

scheduler.cron '0 0 1 * * ' do
 ClinetFee.calculate_fee
end
# scheduler.every 1.month do
  # runner 'ClinetFee.calculate_fee'
# end
# scheduler.join