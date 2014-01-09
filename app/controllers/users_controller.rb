class UsersController < ApplicationController
#skip_before_filter
before_filter :authenticate_user!
skip_before_filter :authenticate_user! , :only => [:reset_password]

  def index
    @users=User.where(:admin=>false).order('client_name ASC')
  end

  def new
    @user = User.new
    @user.bank_details.build
    unless current_user.admin?
      
      redirect_to current_races_races_path
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "#{@user.client_name} successfully created"
      redirect_to users_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if params[:id]=="password"
      @user=current_user
    else
     @user=User.find(params[:id])  
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "User Successfully updated ."
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end

  def delete
  end

  def destroy
    redirect_to users_path and return if params[:cancel]
     @user=User.find(params[:id])
     @users=User.where(:admin=>false).order('client_name ASC')   
     @user.destroy
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
   @user=User.find params[:id]
 
   @user.update_attributes(params[:user])
   flash[:notice] = "User Successfully updated."
   redirect_to view_clients_balance_races_path
  end
  
  def view_report
    @user=User.find params[:id]    
   puts @user.races.count
  end
  
  def withdraw_request
    @user=current_user
    @withdraw=Withdraw.new(:user_id=>@user.id)
  end
  
  def withdraw_history
    @user=current_user
  
  end
  
  end