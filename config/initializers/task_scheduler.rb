require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.new
scheduler.every("10s") do
   Race.bet_reminder
end
# scheduler.join