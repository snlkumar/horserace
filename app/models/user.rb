class User < ActiveRecord::Base
  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password,:reset_password_token, :password_confirmation,:admin, :remember_me,:client_name,:balance,:balance_after_bet,:tier_id,
  :phone,:is_this_trial,:status,:trading_start_date,:trail_duration
  belongs_to :tier
  validates :client_name,:presence=>true,:if =>:client_name_changed?
  validates :phone,:numericality =>true,:unless=> :is_admin?
  validates :balance,:presence=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ },:numericality =>{:greater_than => 0},:if =>:balance_changed?
  validates :tier_id,:presence=>true,:if =>:tier_id_changed?
  validates_format_of :client_name, :with => /^[a-zA-Z() ]+$/
  has_and_belongs_to_many :races,:join_table => :users_races
  before_destroy :check_for_races
  after_create :update_races
  
  def is_admin?
    self.admin?    
  end
  
  def update_races 
    unless self.admin? and self.status=="inactive"
    # @races=Race.where('status=? and date >= ?',nil,self.trading_start_date)
     @races=Race.where('date >=?',self.trading_start_date)
    @races.each do |race|     
      
    UsersRaces.create(:race_id=>race.id,:user_id=>self.id,:processing_balance=>self.balance)
    User.update(self.id,:balance=>self.calculated_balance_after_bet(race))
   
   end
   end
  end
  
  def self.check_trail_duration
    today=Date.today
    users=User.where(:is_this_trial=>true)   
    users.each do |user|
       trail_expire_date=(user.created_at+user.trail_duration.days).strftime("%Y-%m-%d")
       if trail_expire_date == (Date.today+3.days).strftime("%Y-%m-%d")
         user.inactivate
       end
    end
  end
  
  def inactivate
    User.update(self.id,:status=>'inactive',:is_this_trial=>false)
    
  end
  
  def check_for_races
   user_race= UsersRaces.find_by_user_id(self.id)
   unless user_race.blank?     
    self.errors[:base] << "Cannot delete user while its race exists."
    return false   
  end 
  end
  
 def balance_before_bet(race)
 processing_amount=UsersRaces.find_by_race_id_and_user_id(race.id,self.id).processing_balance
 return processing_amount
 end
  def bet_amount(race)
    processing_amount=UsersRaces.find_by_race_id_and_user_id(race.id,self.id).processing_balance
    unless self.is_this_trial?
    case processing_amount
    when 500.0..999.0
      return 5
    when 1000.0..1999.0
      return 10
    when 2000.0..2999.0
      return 20   
    when 3000.0..3999.0
      return 30
    when 4000.0..4999.0
      return 40
    when 5000.0..7499.0
      return 50
    when 7500.0..9999.0
      return 75
    when 10000.0..14999.0
      return 100
    when 15000.0..19999.0
      return 150
    when 20000.0..24999.0
      return 200
    else
      Puts "out of range"                
    end
    else
      return 5
    end
    
  end
  def calculated_balance_after_bet(race)
  
    processing_amount=UsersRaces.find_by_race_id_and_user_id(race.id,self.id).processing_balance
    return processing_amount.to_f-self.bet_amount(race).to_f
  end
  def potential_win(race)
    win= self.bet_amount(race).to_f*2
  return win
  end
  def potential_loss(race)
    unless self.tier.nil?
    @tier_odd= race.default_odd+race.default_odd*self.tier.weight/100   
    else
      @tier_odd=race.default_odd
    end 
    loss=@tier_odd*self.bet_amount(race)
     return loss   
  end
  
  def potential_win_and_update(race)
    win= self.bet_amount(race).to_f*2
    actual_balance=self.balance+win
    if race.status=="win"
      User.update(self.id,:balance=>actual_balance)
    end
  return win
  end
  def potential_loss_and_update(race)
    unless self.tier.nil?
    @tier_odd= race.default_odd+race.default_odd*self.tier.weight/100
    else
      @tier_odd=race.default_odd
    end
    loss=@tier_odd*self.bet_amount(race)
    actual_balance=self.balance-loss
    if race.status=="lost"
      User.update(self.id,:balance=>actual_balance)
    end
    return loss
   
  end
end
