class UsersController < ApplicationController
#skip_before_filter
before_filter :authenticate_user!
skip_before_filter :authenticate_user! , :only => [:reset_password]
  
  def reset_password
    @user=User.find params[:id]
    @user.reset_password_token = params[:reset_password_token]
      sign_in(:user, @user)
     redirect_to edit_user_registration_path
  end
  def confirm_password
    password=params[:password]
    @client=Client.find params[:id]
    @html=""
   if current_user.valid_password?(params[:password])
     @html=render_to_string(:partial => 'clients/change_balance')
   else
    @html=render_to_string(:text => 'You are not a valid user to update balance')
   end
   
   respond_to do |format|
     format.json { render :json => {:valid=>true,:html=>@html} }
   end
  end
 def update_balance
   @user=User.find params[:id] 
   @balance=params[:user][:balance]
   @balance_before_update=@user.balance
   @transaction=Transaction.new(:user_id=>@user.id)
   @user.update_attributes(params[:user])
   if @user.balance > @balance_before_update
   @transaction.deposit=@balance
   else
      @transaction.withdraw=@balance
   end
   @transaction.total=@user.balance
   @transaction.owner=current_user.id
   @transaction.save
   flash[:notice] = "User Successfully updated."
   redirect_to view_clients_balance_races_path
  end
  
  def view_clients
  @clients=Client.all   
  end
  def edit_client
    @client=Client.find(params[:id])
  end
  def update_client
    @client=Client.find(params[:id])
   if @client.update_attributes(params[:client])
      flash[:notice] = "Client Successfully updated ."
      redirect_to user_view_clients_path
    else
      redirect_to user_edit_client_path(:id=>@client)
    end
  end
  
 end