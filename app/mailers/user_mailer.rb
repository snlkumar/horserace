class UserMailer < ActionMailer::Base
  
  default :from => "snlkumar1313@gmail.com"
  
  def race_reminder_mail
    mail(:to => "admin@gmail.com", :subject => "Race Reminder")
  end
   def protest_mail(race,client)
    mail(:to => client.user.email, :subject => "Race {race.name} has been protested")
  end
end
