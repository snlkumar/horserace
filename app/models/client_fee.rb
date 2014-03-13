class ClientFee < ActiveRecord::Base
  attr_accessible :client_id, :month, :new_balance,:old_balance,:balance_before_fee,:fee,:profit
  belongs_to :client
  
  
  def self.calculate_fee
   @clients = Client.where(:status=>"Active")
   unless @clients.blank?
     @clients.each do |client|
       unless client.client_fees.last.blank?
         puts "i am in calculate balance change"
         last_balance=client.client_fees.last.new_balance
         profit=client.balance-last_balance
         unless profit < 0
         fee=profit*client.fee/100
         balance=client.balance-fee
         ClientFee.create(:client_id=>client.id,:month=>Date::MONTHNAMES[Date.today.month],:old_balance=>last_balance,:balance_before_fee=>client.balance,:new_balance=>balance,:profit=>profit,:fee=>fee)
         Client.update(client.id,:balance=>balance)
         end       
       end
     end
   end
  end
  
  
end
