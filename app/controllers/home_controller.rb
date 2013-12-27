class HomeController < ApplicationController
  def index
    if current_user.nil?
    render :layout =>false
    else
      redirect_to current_races_races_path
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
