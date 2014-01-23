class Transaction < ActiveRecord::Base
   attr_accessible :client_id,:total,:owner,:race_status,:deposit,:withdraw,:race_id, :bank_detail_id,:balance_before,:balance_after
   belongs_to :client
   belongs_to :race
   belongs_to :bank_detail
   # validates :bank_detail,:presence=>true
   before_create :validate_amount,:if=>:withdraw_changed?

 def validate_amount
   user=Client.find self.client_id
   if user.balance<self.withdraw 
     self.errors[:base] << "Amount should be equal or less than the available balance"
     return false
   end
 end
  
  def self.create_bank(withdraw,bsb,acount,bank_name,account_name,client_id)
    @bank=BankDetail.new(:bsb=>bsb,:account=>acount,:bank_name=>bank_name,:account_name=>account_name,:client_id=>client_id)
    if @bank.save
      return @bank.id      
    else
      withdraw.errors[:base] << @bank.errors.messages
    return false
    end
  end
end
