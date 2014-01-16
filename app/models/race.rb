class Race < ActiveRecord::Base
  attr_accessible :name, :date,:time, :horse,:horse_no, :default_odd,:status,:ticket_number,:location,:users,:race_type,:description
  validates :name,:horse,:default_odd,:presence=>true
  validates :default_odd,:presence=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ },:numericality =>{:greater_than => 0}
  after_create :update_users
  has_and_belongs_to_many :users,:join_table => :users_races
  has_many :transactions
  validates_format_of :name,:horse, :with => /^[a-zA-Z() ]+$/
  validates :ticket_number,:uniqueness=>true
  def update_users 
    @users=User.where('admin=? AND status=? AND balance>=?',false,'active',500)
    # @users=User.where(:admin=>false,:status=>'active') 
    @users.each do |user|
      # trading_date=user.trading_start_date
#      
      # if trading_date <= self.date      
    user_race=UsersRaces.create(:race_id=>self.id,:user_id=>user.id,:processing_balance=>user.balance)
    UsersRaces.update(user_race.id,:bet_amount=>user.bet_amount(self))
    User.update(user.id,:balance=>user.calculated_balance_after_bet(self))
    unless user_race.nil?
    ur=UsersRaces.find user_race.id
    Transaction.create(:balance_before=>ur.processing_balance,:balance_after=>ur.processing_balance-ur.bet_amount,:withdraw=>ur.bet_amount,:race_id=>self.id,:user_id=>user.id,:bank_detail_id=>user.bank_details.last.id)
      end
   end
  end
    
  
  def self.bet_reminder
    
    current_time=Time.now
    @races= Race.where(:date=>Date.today,:time=>(Time.now-10.minutes).strftime("%H:%M"))
    unless @races.blank?      
      @races.each do |race|
        (UserMailer.race_reminder_mail).deliver
      end
    end
  end
end
