class ClientsController < InheritedResources::Base
  before_filter :login_required
  before_filter :reseller_required ,:only=>[:new,:create,:destroy]
  before_filter :admin_or_reseller,:only=>[:edit,:update]
  def index
    @reseller=Reseller.find params[:reseller_id]
    @clients=@reseller.clients.order('status DESC')
  end
  
  def new
    @reseller=current_user.reseller
    @client = Client.new(:reseller_id=>@reseller.id)
    @client.build_user
    @client.bank_details.build
  end
  
  def edit
     @reseller=Reseller.find params[:reseller_id]
    @client=Client.find(params[:id])
   
  end
  
  def create
    @reseller=Reseller.find params[:reseller_id]
    @client = Client.new(params[:client])
    if @client.save
      flash[:notice] = "Client successfully created"
      redirect_to reseller_clients_path(current_user.reseller)
    else
      render :action => 'new'
    end
  end
  
  def update
    @reseller=Reseller.find params[:reseller_id]
    params[:client].delete(:password) if params[:client][:password].blank?
    params[:client].delete(:password_confirmation) if params[:client][:password].blank? and params[:client][:password_confirmation].blank?
    if params[:id]=="password"
      @client=current_user
    else
     @client=Client.find(params[:id])  
    end
    
    if @client.update_attributes(params[:client])
      flash[:notice] = "Client Successfully updated ."
      redirect_to reseller_clients_path(@reseller)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @reseller=Reseller.find params[:reseller_id]
    redirect_to reseller_clients_path(@reseller) and return if params[:cancel]
     @client=Client.find(params[:id])
     @clients=Client.order('client_name ASC')   
     @client.destroy
     respond_to do |format|
      format.html { render 'index' }
      format.json { head :no_content }
    end
  end
  def reset_password
    @user=User.find params[:id]
    @user.reset_password_token = params[:reset_password_token]
      sign_in(:user, @user)
     redirect_to edit_user_registration_path
  end
  def confirm_password
    password=params[:password]
    @user=User.find params[:id]
    @html=""
   if current_user.valid_password?(params[:password])
     @html=render_to_string(:partial => 'change_balance')
   else
    @html=render_to_string(:text => 'You are not a valid user to update balance')
   end
   
   respond_to do |format|
     format.json { render :json => {:valid=>true,:html=>@html} }
   end
  end
 def update_balance
   @user=Client.find params[:id] 
   @balance=params[:client][:balance]
   @balance_before_update=@user.balance
   @transaction=Transaction.new(:client_id=>@user.id)
   @user.update_attributes(params[:client])
   if @user.balance > @balance_before_update
   @transaction.deposit=@balance
   else
      @transaction.withdraw=@balance
   end
   @transaction.total=@user.balance
   @transaction.owner=current_user.id
   @transaction.save
   flash[:notice] = "Client Successfully updated."
   redirect_to view_clients_balance_races_path
  end
  
  def view_report
    @client=Client.find params[:id]       
  end
  
  def withdraw_request
    @user=current_user.client
    @transaction=Transaction.new(:client_id=>@user.id,:balance_before=>@user.balance)
  end
   
  
  def withdraw_history
    @user=current_user.client
  end
  def respond_way
    @client=current_user.client
    @reseller=@client.reseller
    if request.put?
      if @client.update_attributes(params[:client])
      flash[:notice] = "Client Detail Successfully updated ."
      redirect_to respond_way_reseller_clients_path(@reseller)
    end
    end
  end
  
  def my_details
    @client=current_user.client
    @reseller=@client.reseller
  end
  def update_details
    
    @reseller=Reseller.find params[:reseller_id]
     @client=current_user.client
     if @client.update_attributes(params[:client])
      flash[:notice] = "Client Detail Successfully updated ."
      redirect_to my_details_reseller_clients_path(@reseller)
    else
      render :action => 'my_details'
    end
  end
  
  
  
  
  
end
