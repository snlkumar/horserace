class ApplicationController < ActionController::Base
  protect_from_forgery

def index
 
   redirect_to new_user_path
end

def login_required
 unless current_user
 redirect_to root_path
 end
end
def admin_required
 unless current_user and current_user.admin?
 redirect_to root_path
 end
end

def reseller_required
 unless current_user.reseller_id?
   flash[:notice]="Sorry you are not allowed for this action"
 redirect_to root_path
 end
end
end
