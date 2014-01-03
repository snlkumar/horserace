class User < ActiveRecord::Base
  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password,:reset_password_token, :password_confirmation,:admin, :remember_me,:client_name,:balance,:balance_after_bet,:tier_id,:phone
  belongs_to :tier
  validates :client_name,:presence=>true,:if =>:client_name_changed?
  validates :balance,:presence=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ },:numericality =>{:greater_than => 0},:if =>:balance_changed?
  validates :tier_id,:presence=>true,:if =>:tier_id_changed?
  validates_format_of :client_name, :with => /^[a-zA-Z() ]+$/
   has_and_belongs_to_many :races,:join_table => :users_races
 def balance_before_bet(race)
 processing_amount=UsersRaces.find_by_race_id_and_user_id(race.id,self.id).processing_balance
 return processing_amount
 end
  def bet_amount(race)
    processing_amount=UsersRaces.find_by_race_id_and_user_id(race.id,self.id).processing_balance
   
    return processing_amount*1/100 unless processing_amount.blank?
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
    tier_odd= race.default_odd+race.default_odd*self.tier.weight/100   
    loss=tier_odd*self.bet_amount(race)
     return loss   
    end
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
    tier_odd= race.default_odd+race.default_odd*self.tier.weight/100
    loss=tier_odd*self.bet_amount(race)
    actual_balance=self.balance-loss
    if race.status=="lost"
      User.update(self.id,:balance=>actual_balance)
    end
    return loss
    end
  end
end
