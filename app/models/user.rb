class User < ActiveRecord::Base
  
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password,:reset_password_token, :password_confirmation,:admin, :remember_me,:client_name,:balance,:tier_id,:phone
  belongs_to :tier
  validates :client_name,:presence=>true,:if =>:client_name_changed?
  validates :balance,:presence=>true,:if =>:balance_changed?
  validates :tier_id,:presence=>true,:if =>:tier_id_changed?

 
  def bet_amount
    return self.balance*1/100 unless self.balance.blank?
  end
  def balance_after_bet
    return self.balance.to_f-self.bet_amount.to_f
  end
  def potential_win
    win= self.bet_amount.to_f*2
  return win
  end
  def potential_loss(race)
    unless self.tier.nil?
    tier_odd= race.default_odd+race.default_odd*self.tier.weight/100   
    loss=tier_odd*self.bet_amount
     return loss   
    end
  end
  
  def potential_win_and_update(race)
    win= self.bet_amount.to_f*2
    actual_balance=self.balance+win
    if race.status=="win"
      User.update(self.id,:balance=>actual_balance)
    end
  return win
  end
  def potential_loss_and_update(race)
    unless self.tier.nil?
    tier_odd= race.default_odd+race.default_odd*self.tier.weight/100
    loss=tier_odd*self.bet_amount
    actual_balance=self.balance-loss
    if race.status=="lost"
      User.update(self.id,:balance=>actual_balance)
    end
    return loss
    end
  end
end
