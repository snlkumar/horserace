class WithdrawsController < InheritedResources::Base
  
  def create
    @user=current_user
    bsb=params[:bsb]
    acount=params[:account]
    bank_name=params[:bank_name]
    account_name=params[:account_name]
    respond_to do |format|
      @withdraw=Withdraw.new(params[:withdraw])
   if current_user.valid_password?(params[:password])
    
    if params[:withdraw][:bank_detail_id].blank?
      bank_id= Withdraw.create_bank(@withdraw,bsb,acount,bank_name,account_name,current_user.id)
      @withdraw.bank_detail_id=bank_id
      
    end    
      if @withdraw.errors.count==0
      if @withdraw.save
        format.html { redirect_to user_withdraw_request_path, notice: 'Withdraw request received successfully.' }
        format.json { render json: @withdraw, status: :created, location: @post }
      else
        format.html { render 'users/withdraw_request',:user=>current_user, notice: @withdraw.errors}
        format.json { render json: @withdraw.errors, status: :unprocessable_entity }
      end
      else
        format.html { render 'users/withdraw_request',:user=>current_user, notice: @withdraw.errors }
        format.json { render json: @withdraw.errors, status: :unprocessable_entity }
      end
      else        
           @withdraw.errors[:base] << 'Invalid password'
         format.html { render 'users/withdraw_request',:user=>current_user, notice: @withdraw.errors}
        format.json { render json: @withdraw.errors, status: :unprocessable_entity }
      end
    end  
  end
end
