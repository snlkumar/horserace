class TransactionsController < InheritedResources::Base
  def new
    @transaction=Transaction.new
  end
  def create
    puts "i am in withdraw with params#{params}"
    @user=current_user.client
    bsb=params[:bsb]
    acount=params[:account]
    bank_name=params[:bank_name]
    account_name=params[:account_name]
    respond_to do |format|
      @transaction=Transaction.new(params[:transaction])
   if current_user.valid_password?(params[:password])
        if params[:amount_to]=="deposit"
              if  UserMailer.send_balance_deposit_mail(@user,params[:deposit_messages],"deposit").deliver
                  format.html { redirect_to withdraw_request_reseller_clients_path(current_user.client.reseller), notice: 'Request received successfully.' }
             else
                  format.html { redirect_to withdraw_request_reseller_clients_path(current_user.client.reseller), notice: 'Failed to Send Emails, try again.' }
             end
          format.json { render json: @transaction, status: :created, location: @user }
        else
          puts "i am in transaction#{}"
          if  UserMailer.send_balance_deposit_mail(@user,@transaction.withdraw,"withdraw").deliver
                  format.html { redirect_to withdraw_request_reseller_clients_path(current_user.client.reseller), notice: 'Request received successfully.' }
             else
                  format.html { redirect_to withdraw_request_reseller_clients_path(current_user.client.reseller), notice: 'Failed to Send Emails, try again.' }
             end
          format.json { render json: @transaction, status: :created, location: @user }
          
          # if params[:transaction][:bank_detail_id].blank? && !account_name.blank?
              # bank_id= Transaction.create_bank(@transaction,bsb,acount,bank_name,account_name,current_user.client.id)
              # @transaction.bank_detail_id=bank_id
#               
            # end    
              # if @transaction.errors.count==0            
#                 
                  # if @transaction.save
                    # unless @transaction.withdraw.blank?
                      # after_balance=@user.balance-@transaction.withdraw
                      # Client.update_balance(@user,after_balance)                
                    # end      
                     
                    # unless @transaction.deposit.blank?        
                      # @user =Client.find current_user.client.id  
                      # after_balance=@user.balance+@transaction.deposit          
                     # Client.update_balance(@user,after_balance)  
                     # Client.update(@user.id,:initial_balance=>after_balance)       
                    # end
                     # user =Client.find current_user.client.id 
                     # @transaction.update_attributes(:balance_after=>user.balance,:owner=>user.id)
#                  
                    # format.html { redirect_to withdraw_request_reseller_clients_path(current_user.client.reseller), notice: 'Request received successfully.' }
                    # format.json { render json: @transaction, status: :created, location: @user }
                  # else
                    # # format.html { render 'clients/withdraw_request',:user=>current_user.client, notice: @transaction.errors}
                    # # format.json { render json: @transaction.errors, status: :unprocessable_entity }
                  # end
              # else
                    # # format.html { render 'clients/withdraw_request',:user=>current_user.client, notice: @transaction.errors }
                    # # format.json { render json: @transaction.errors, status: :unprocessable_entity }
              # end
              
              #end of the params
           end
      else        
           @transaction.errors[:base] << 'Invalid password'
         format.html { render 'clients/withdraw_request',:user=>current_user.client, notice: @transaction.errors}
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end  
  end
end
