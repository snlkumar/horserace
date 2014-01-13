class Withdraw < ActiveRecord::Base
  attr_accessible :amount,:bank_detail_id,:user_id
  belongs_to :user
  belongs_to :bank_detail
  validates :bank_detail,:presence=>true
  before_save :validate_amount

 def validate_amount
   user=User.find self.user_id
   if user.balance<self.amount
     self.errors[:base] << "Amount should be equal or less than the available blance"
     return false
   end
 end
  
  def self.create_bank(withdraw,bsb,acount,bank_name,account_name,user_id)
    @bank=BankDetail.new(:bsb=>bsb,:account=>acount,:bank_name=>bank_name,:account_name=>account_name,:user_id=>user_id)
    if @bank.save
      return @bank.id      
    else
      withdraw.errors[:base] << @bank.errors.messages
    return false
    end
  end
end
