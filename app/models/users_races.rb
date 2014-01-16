class UsersRaces < ActiveRecord::Base
  attr_accessible :user_id,:race_id,:processing_balance,:win,:lost,:bet_amount
  belongs_to :user
  belongs_to :race
  
  
  def balance_after_result(race)
  @balance= self.processing_balance-self.bet_amount
   if self.win
     @balance+=self.win
   end
   if self.lost
     @balance-=self.lost
   end 
   unless race.status.blank?
   return @balance
   else
     return "pending"
   end
  end
  
  
  
  
end
