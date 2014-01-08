class UserMailer < ActionMailer::Base
  
  default :from => "snlkumar1313@gmail.com"
  
  def race_reminder_mail
    mail(:to => "admin@gmail.com", :subject => "Race Reminder")
  end
end
