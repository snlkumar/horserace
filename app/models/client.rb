class Client < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :client_name,:balance,:fee,:balance_after_bet,:tier_id,:bet,
  :phone,:is_this_trial,:initial_balance,:status,:enquiry,:trading_start_date,:trail_duration,:address,:reseller_id,:custom_password,:ticket_number,:respond_via, :dob, :consultant_name, :consultant_contact_number,:client_number,:withdraws_attributes,:user_attributes, :bank_details_attributes
  belongs_to :tier
  validates :client_name,:presence=>true,:if =>:client_name_changed?
  validates :client_number,:uniqueness=>true
  validates :phone,:numericality =>true
  validates :balance,:presence=>true,:format => { :with => /^\d+??(?:\.\d{0,2})?$/ },:numericality =>{:greater_than => 0},:if =>:balance_changed?
  # validates :tier_id,:presence=>true,:if =>:tier_id_changed?
  # validates_format_of :client_name, :with => /^[a-zA-Z() ]+$/
  has_and_belongs_to_many :races,:join_table => :users_races
  has_many :bank_details
  has_many :withdraws
  has_many :client_fees
  has_many :transactions
  accepts_nested_attributes_for :withdraws
  accepts_nested_attributes_for :bank_details
  before_destroy :check_for_races
  after_destroy :delete_user
  after_create :client_fee
  before_save :validate_balance
  # validate :status,:update_races,:if =>:status_changed?,:on=>'update'
   has_one :user
   belongs_to :reseller
   accepts_nested_attributes_for :user
   
   
  def client_fee
    ClientFee.create(:client_id=>self.id,:month=>Date::MONTHNAMES[Date.today.month],:new_balance=>self.balance)
    Client.update(self.id,:bet=>self.set_daily_bet_amount)
  end 
   
  def validate_balance
    if (self.balance < 500 unless self.balance.nil?)
      self.errors[:base] << "The requested Balance should be equal or greater than $500"
     return false
    end
  end
  
  def delete_user
    self.user.delete
    unless self.client_fees.blank?
      self.client_fees.each do |cf|
        cf.delete
      end
    end
  end
  
  def update_races 
   
   
    unless self.status=="Inactive"
    # @races=Race.where('status=? and date >= ?',nil,self.trading_start_date)
     #@races=Race.where('date >=?',self.trading_start_date)
     @races=Race.where(:status=>nil)    
     @races.each do |race|     
      
     user_race= UsersRaces.create(:race_id=>race.id,:client_id=>self.id,:processing_balance=>self.balance)
     UsersRaces.update(user_race.id,:bet_amount=>self.bet_amount(race))
     Client.update(self.id,:balance=>self.calculated_balance_after_bet(race),:bet_amount=>self.set_daily_bet_amount)
      unless user_race.nil?
    ur=UsersRaces.find user_race.id
     Transaction.create(:balance_before=>ur.processing_balance,:balance_after=>ur.processing_balance-ur.bet_amount,:withdraw=>ur.bet_amount,:race_id=>race.id,:client_id=>self.id)
     end
    end
   end
  end
  
  def self.check_trail_duration
    today=Date.today
    clients=Client.where(:is_this_trial=>true)   
    clients.each do |client|
       trail_expire_date=(client.created_at+client.trail_duration.days).strftime("%Y-%m-%d")
       if trail_expire_date == (Date.today+3.days).strftime("%Y-%m-%d")
         client.inactivate
       end
    end
  end
  
  
  def self.update_daily_bet_amount    
   
    clients=Client.where(:status=>"Active")   
    clients.each do |client|
       puts "i am in update daily bet amoubt with#{client.client_name}"
      bet=client.set_daily_bet_amount
      Client.update(client.id,:bet=>bet)
    end
  end
  
  
  def inactivate
    Client.update(self.id,:status=>'inactive',:is_this_trial=>false)
    
  end
  
  def check_for_races
   user_race= UsersRaces.find_by_client_id(self.id)
   unless user_race.blank?     
    self.errors[:base] << "Cannot delete user while it's race exists."
    return false   
  end 
  end
  
 def balance_before_bet(race)
  
 processing_amount=UsersRaces.find_by_race_id_and_client_id(race.id,self.id).processing_balance
 return processing_amount
 end
  def bet_amount(race)
    processing_amount=UsersRaces.find_by_race_id_and_client_id(race.id,self.id).processing_balance
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
             bet = 200 
             after_diff=processing_amount-25000
             puts "the calculated value is#{(after_diff/5000).floor}"
             reminder=(after_diff/5000).floor+1
             return bet+reminder*50            
         end
    else
      return 5
    end
    
  end
  #change betamount method
  def set_daily_bet_amount
    processing_amount=self.balance
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
             bet = 200 
             after_diff=processing_amount-25000
             puts "the calculated value is#{(after_diff/5000).floor}"
             reminder=(after_diff/5000).floor+1
             return bet+reminder*50            
         end
    else
      return 5
    end
    
  end
  #change betamount method
  def calculated_balance_after_bet(race)  
    processing_amount=UsersRaces.find_by_race_id_and_client_id(race.id,self.id).processing_balance
    # return processing_amount.to_f-self.bet_amount(race).to_f
    return processing_amount.to_f-self.bet.to_f
  end
  def potential_win(race)
    # win= self.bet_amount(race).to_f*2
    win= self.bet.to_f*2
  return win
  end
  def potential_loss(race)
    unless self.tier.nil?
    @tier_odd= race.default_odd+race.default_odd*self.tier.weight/100   
    else
      @tier_odd=race.default_odd
    end 
    # loss=(@tier_odd).round(2)*self.bet_amount(race)
    loss=(@tier_odd).round(2)*self.bet-self.bet
     return loss   
  end
  
  def race_potential_loss(race)
    
  end
  
  def potential_win_and_update(race)
    @user_races=UsersRaces.find_by_race_id_and_client_id(race.id,self.id)
    # win= self.bet_amount(race).to_f*2
    win= self.bet.to_f*2
    actual_balance=self.balance+win
    if race.status=="win"
      Client.update(self.id,:balance=>actual_balance)
      # UsersRaces.update(@user_races.id,:win=>win,:bet_amount=>self.bet_amount(race))
      UsersRaces.update(@user_races.id,:win=>win,:bet_amount=>self.bet)
      trans=Transaction.find_by_client_id_and_race_id(self.id,race.id)
      Transaction.create(:balance_before=>trans.balance_after,:balance_after=>actual_balance,:deposit=>win,:race_id=>race.id,:race_status=>'Win',:client_id=>self.id)
    end
  return win
  end
  def potential_loss_and_update(race)
    @user_races=UsersRaces.find_by_race_id_and_client_id(race.id,self.id)
    unless self.tier.nil?
    @tier_odd= race.default_odd+race.default_odd*self.tier.weight/100
    else
      @tier_odd=race.default_odd
    end
    # loss=@tier_odd*self.bet_amount(race)
    
    loss=(@tier_odd).round(2)*self.bet-self.bet
    # actual_balance=self.processing_balance-loss
    actual_balance=self.balance+self.bet-loss
    if race.status=="lost"
      Client.update(self.id,:balance=>actual_balance)
      # UsersRaces.update(@user_races.id,:lost=>loss,:bet_amount=>self.bet_amount(race))
      UsersRaces.update(@user_races.id,:lost=>loss,:bet_amount=>self.bet)
      trans=Transaction.find_by_client_id_and_race_id(self.id,race.id)
      Transaction.create(:balance_before=>trans.balance_after,:balance_after=>actual_balance,:withdraw=>loss,:race_id=>race.id,:race_status=>'Lost',:client_id=>self.id)
    end
    return loss
   
  end
  
  def profit_lost
    # race=self.races.first
    # @win=0.0
    # @lost=0.0
    # win_races=UsersRaces.where('win IS NOT NULL AND client_id=?',self.id) unless race.nil?
    # lost_races=UsersRaces.where('lost IS NOT NULL AND client_id=?',self.id) unless race.nil?
    # unless win_races.blank?
    # win_races.each do |wr|
      # @win+=wr.win
    # end
    # end
    # unless lost_races.blank?
    # lost_races.each do |lr|
      # @lost+=lr.lost
    # end
    # end
    # puts "the win#{@win} and lost#{@lost}"
    # @user_races=UsersRaces.find_by_race_id_and_client_id(race.id,self.id) unless race.nil?    
     return total_profit_lost*100/self.initial_balance unless self.initial_balance.blank?
    
  end
  
  
   def total_profit_lost
    # race=self.races.first
    # @win=0.0
    # @lost=0.0
    # win_races=UsersRaces.where('win IS NOT NULL AND client_id=?',self.id) unless race.nil?
    # lost_races=UsersRaces.where('lost IS NOT NULL AND client_id=?',self.id) unless race.nil?
     # unless win_races.blank?
    # win_races.each do |wr|
      # @win+=wr.win
    # end
    # end
     # unless lost_races.blank?
    # lost_races.each do |lr|
      # @lost+=lr.lost
    # end
    # end
    # puts "the win#{@win} and lost#{@lost}"
    # # @user_races=UsersRaces.find_by_race_id_and_client_id(race.id,self.id) unless race.nil?
    # unless @win.blank?
     # return (@win-@lost)
    # end
    puts "#{self.initial_balance} and #{self.balance}"
    return self.balance-self.initial_balance
  end
  
  
  def b5
    puts "i am in b5 with params#{self.total_profit_lost < 0}"
    unless self.total_profit_lost.blank?
      if self.total_profit_lost > 0
        self.total_profit_lost*5/100
       else
         0
         end  
  end
  end
  
  def self.update_balance(user,balance)
    Client.update(user.id,:balance=>balance)
      
  end
  
  def thirty_day_history
    @deposit=0.0
    @withdraw=0.0
    transactions=self.transactions.where('DATE(created_at)<? AND DATE(created_at)>? AND race_id IS NOT NULL',Date.today+1.day,Date.today-30.days)
    transactions.each do |t|
      @deposit+=t.deposit unless t.deposit.blank?
      @withdraw+=t.withdraw unless t.withdraw.blank?
    end
    return @deposit-@withdraw
    
  end
   
   def prev_monthly_fees_paid
     @total_fees=0.0
     @clien_fees=self.client_fees
     unless @clien_fees.blank?
       # @clien_fees.each do |cf|
         @total_fees=@clien_fees.last.fee 
       # end
       return @total_fees
     end
   end
   
   def total_fees_paid
      @total_fees=0.0
     @clien_fees=self.client_fees
     unless @clien_fees.blank?
        @clien_fees.each do |cf|
         @total_fees+=cf.fee unless cf.fee.blank? 
        end
       return @total_fees
     end
   end
   
   def fund_in_trades
     @races= self.races.where(:status=>nil)
     @funds=0.0
     unless @races.blank?
       @races.each do |race|
         user_races=UsersRaces.find_by_race_id_and_client_id(race.id,self.id)
         puts user_races.attributes
         @funds+=user_races.bet_amount
       end
       return @funds
     end
   end
   
   
end
