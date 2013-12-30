class RacesController < InheritedResources::Base
  def show
    @race=Race.find(params[:id])
    @tiers=Tier.all
    @users=User.where(:admin => false)
    
  end
  
  def current_races
     @races=Race.where(:status=>nil)
     @tiers=Tier.all
     @user=User.where(:admin => false)
  end
  
  def change_status
    @race=Race.find(params[:id])   
    render 'change_status' 
  end
  def update_status
    puts "i am with params#{params}"
     @race=Race.find(params[:original_value])  
     @tiers=Tier.all
     @users=User.where(:admin => false)
     @race.update_attributes(:status=>params[:update_value])
     render 'race_result',:layout=>false
  end
  
  def view_clients_balance
    @final=params[:id]
    @users=User.where(:admin => false)
    render 'client_balances'
  end
  def contacts
    @users=User.where(:admin => false)
  end
  def view_prev_races
    date=params[:date]
    @races=Race.where(:date=>date)
   render :partial=>'prev_races'
  end
  
  
end
