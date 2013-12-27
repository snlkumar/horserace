class User::RegistrationsController < Devise::RegistrationsController
  before_filter :require_no_authentication
  
  def index
    
  end
  def new
   
  end
  def edit
    
  end
   def after_sign_up_path_for(resource)
    
    after_sign_in_path_for(resource)
  end

  ## other actions 
end