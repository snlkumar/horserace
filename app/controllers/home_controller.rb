class HomeController < ApplicationController
  def index
    if current_user.nil?
    render :layout =>false
    else if current_user.reseller
      @reseller=current_user
      redirect_to new_reseller_client_path(@reseller.reseller)
    else
      redirect_to current_races_races_path
    end
    end
  end
  def change_password
    @user=current_user
    if request.post?
      @user.update_attribute(params[:user])
      puts "thehhhhhh#{@user.errors.messages}"
      redirect_to root_path
    end
  end
  
end
