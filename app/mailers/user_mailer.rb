class UserMailer < ActionMailer::Base
  
  default :from => "snlkumar1313@gmail.com"
  
  def race_reminder_mail
    mail(:to => "sunil.kumar@trigma.co.in", :subject => "Race Reminder",:body=>"This is heroku server from local")
  end
   def protest_mail(race,client)
    mail(:to => client.user.email, :subject => "Race {race.name} has been protested")
  end
  def send_balance_deposit_mail(client,message)
     mail(:to => "sunil.kumar@trigma.co.in", :subject =>"Deposit amount" ,:body=>"#{message}")
  end
  def respond_via(client,message)
    mail(:to => client.reseller.user.email, :subject =>"Enquiry" ,:body=>"#{message}")
  end
end
