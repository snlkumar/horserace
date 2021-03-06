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
  def edit
    @user = User.find params[:id]
  end
  #change
  def update
    @user = User.find(current_user.id)
   
    if @user.update_with_password(params[:user])
      flash[:notice]="Password has been changed successfully" 
   end
    render 'edit'  
  end
  
  #change
  def update_balance
    puts "i am in update client with params#{params}"
   @client=Client.find(params[:id])
   if @client.update_attributes(params[:client])
     flash[:notice] = "Client Successfully updated ."
      redirect_to user_view_clients_path
    else
      render 'edit_client'
   end
  end
  
  def view_clients
   @clients=Client.where(:status=>'Active').order('created_at DESC')  
   render "view_clients" 
  end
  def inactive_clients
  @clients=Client.where(:status=>'Inactive').order('created_at DESC')
  end
  def edit_client
    @client=Client.find(params[:id])
  end
  def update_client
    @client=Client.find(params[:id])
    @deposit=0.0
    @withdraw=0.0
    before_balance=@client.balance
    balance=params[:client][:balance]
    if before_balance<balance.to_f
    @deposit=balance.to_f-before_balance
    else
    @withdraw=before_balance-balance.to_f  
    end
   if @client.update_attributes(:balance=>balance,:initial_balance=>balance)
      @transaction=Transaction.new(:client_id=>@client.id,:balance_before=>before_balance,:deposit=>@deposit,:owner=>current_user.id,:withdraw=>@withdraw,:balance_after=>@client.balance)
      @transaction.save      
      UserMailer.send_balance_updated_mail(@client).deliver
      flash[:notice] = "Client Successfully updated ."
      redirect_to user_view_clients_path
    else       
      render 'edit_client'
    end
  end
  
  def update_tier
    @clients=Client.where(:status=>'Active').order('created_at DESC') 
    @client=Client.find(params[:element_id])
    tier=Tier.find_by_name(params[:update_value])
    unless tier.nil?
    Client.update(@client.id,:tier_id=>tier.id)
    else
      Client.update(@client.id,:tier_id=>"")
    end
    flash[:notice] = "Tier successfully updated ."
     render :partial=>'user_view_clients'
  end
  
  def delete_client
    puts "i am in delete client with paramser#{params}"
    @client=Client.find(params[:id])
    @client.destroy
    @clients=Client.where(:status=>'Active').order('created_at DESC')
    render 'view_clients'
  end
  def delete_inactive_client    
    @client=Client.find(params[:id])
    @client.destroy
    @clients=Client.where(:status=>'Inactive').order('created_at DESC')
    render 'inactive_clients'
  end
  def search_clients
    input=params[:id]
    unless input=="empty"
    # @clients=Client.find(:all, :conditions => ["client_name like ? AND status=?", "%#{input.downcase}%",'Active'])
    @clients=Client.where("client_name ilike ? AND status=?","%#{input}%","Active")
    else
       @clients=Client.where(:status=>'Active').order('created_at DESC')
    end
    render :partial=> 'user_view_clients'
  end
 end