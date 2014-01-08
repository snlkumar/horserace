class Race < ActiveRecord::Base
  attr_accessible :name, :date,:time, :horse, :default_odd,:status,:ticket_number,:location,:users,:race_type,:description
  validates :name,:horse,:default_odd,:presence=>true
  validates :default_odd,:presence=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ },:numericality =>{:greater_than => 0}
  after_create :update_users
  has_and_belongs_to_many :users,:join_table => :users_races
  validates_format_of :name,:horse, :with => /^[a-zA-Z() ]+$/
  
  def update_users 
    @users=User.where(:admin=>false,:status=>'active') 
    @users.each do |user|
      trading_date=user.trading_start_date
     
      if trading_date <= self.date      
    user_race=UsersRaces.create(:race_id=>self.id,:user_id=>user.id,:processing_balance=>user.balance)
    UsersRaces.update(user_race.id,:bet_amount=>user.bet_amount(self))
    User.update(user.id,:balance=>user.calculated_balance_after_bet(self))
     end
   end
  end
    
  
  def self.bet_reminder
    puts "i am in race mail"
    current_time=Time.now
    @races= Race.where(:date=>Date.today,:time=>(Time.now-10.minutes).strftime("%H:%M"))
    unless @races.blank?      
      @races.each do |race|
        (UserMailer.race_reminder_mail).deliver
      end
    end
  end
end
