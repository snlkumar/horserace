class TransactionsController < InheritedResources::Base
  def new
    @transaction=Transaction.new
  end
  def create
    @user=current_user
    bsb=params[:bsb]
    acount=params[:account]
    bank_name=params[:bank_name]
    account_name=params[:account_name]
    respond_to do |format|
      @transaction=Transaction.new(params[:transaction])
   if current_user.valid_password?(params[:password])
    
    if params[:transaction][:bank_detail_id].blank?
      bank_id= Transaction.create_bank(@transaction,bsb,acount,bank_name,account_name,current_user.id)
      @transaction.bank_detail_id=bank_id
      
    end    
      if @transaction.errors.count==0
            
        
      if @transaction.save
        unless @transaction.withdraw.blank?
          after_balance=@user.balance-@transaction.withdraw
          User.update_balance(@user,after_balance)                
        end      
         
        unless @transaction.deposit.blank?        
          @user =User.find current_user.id  
          after_balance=@user.balance+@transaction.deposit          
         User.update_balance(@user,after_balance)         
        end
         user =User.find current_user.id 
         @transaction.update_attributes(:balance_after=>user.balance)
     
        format.html { redirect_to user_withdraw_request_path, notice: 'Withdraw request received successfully.' }
        format.json { render json: @transaction, status: :created, location: @post }
      else
        format.html { render 'users/withdraw_request',:user=>current_user, notice: @transaction.errors}
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
      else
        format.html { render 'users/withdraw_request',:user=>current_user, notice: @transaction.errors }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
      else        
           @transaction.errors[:base] << 'Invalid password'
         format.html { render 'users/withdraw_request',:user=>current_user, notice: @transaction.errors}
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end  
  end
end
