class ApplicationController < ActionController::Base
  protect_from_forgery

def index
 
   redirect_to new_user_path
end

# private
# def authenticate_user!
  # puts "authonticate user"
# end

end
