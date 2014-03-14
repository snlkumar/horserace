class Race < ActiveRecord::Base
  attr_accessible :name,:horse_place, :date,:time, :horse,:horse_no,:info, :default_odd,:status,:ticket_number,:location,:users,:race_type,:description
  validates :name,:horse,:default_odd,:presence=>true
  validates :default_odd,:presence=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ },:numericality =>{:greater_than => 0}
  after_create :update_clients
  has_and_belongs_to_many :clients,:join_table => :users_races
  has_many :transactions
  # validates_format_of :name,:horse, :with => /^[a-zA-Z() ]+$/
  validates :ticket_number,:uniqueness=>true
  before_destroy :delete_users_races
  def update_clients 
    @clients=Client.where(:status=>'Active')
   
    # @users=User.where(:admin=>false,:status=>'active') 
    @clients.each do |client|
      # trading_date=user.trading_start_date
#      
      # if trading_date <= self.date     
      unless client.balance < 500 
    user_race=UsersRaces.create(:race_id=>self.id,:client_id=>client.id,:processing_balance=>client.balance)
    puts "i am with bet amount#{client.bet_amount(self)}"
    # UsersRaces.update(user_race.id,:bet_amount=>client.bet_amount(self))
    UsersRaces.update(user_race.id,:bet_amount=>client.bet)
    Client.update(client.id,:balance=>client.calculated_balance_after_bet(self))
    unless user_race.nil?
    ur=UsersRaces.find_by_id(user_race.id)
    puts "i am with#{ur.processing_balance} and-#{ur.bet_amount}"
    Transaction.create(:balance_before=>ur.processing_balance,:balance_after=>ur.processing_balance-ur.bet_amount,:withdraw=>ur.bet_amount,:race_id=>self.id,:race_status=>'New',:client_id=>client.id)
      end
   end
   end
  end
    
  
  def self.bet_reminder
    puts "i am in bet reminder with params"
    race=Race.find(:last)
    race.delete unless race.blank?
    # current_time=Time.now
    # @races= Race.where(:date=>Date.today,:time=>(Time.now-10.minutes).strftime("%H:%M"))
    # unless @races.blank?      
      # @races.each do |race|
      #  (UserMailer.race_reminder_mail).deliver
      # end
    # end
  end
   
  def delete_users_races
    puts "i am in with#{self.id}"
    @ur=UsersRaces.where(:race_id=>self.id)
  @ur.each do |ur|
    ur.delete
  end
  end
  
end
