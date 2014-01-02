class RacesController < InheritedResources::Base
  def show
    @race=Race.find(params[:id])
    @tiers=Tier.all
    @users=User.where(:admin => false).order('client_name ASC')    
  end
  
  def create
    super
    flash[:notice]="Race successfully created"
  end
  
  def current_races
     @races=Race.where(:status=>nil).order('date ASC')
     @tiers=Tier.all
     @user=User.where(:admin => false).order('client_name ASC')
  end
  
  def change_status
    @race=Race.find(params[:id])   
    render 'change_status' 
  end
  def update_status
     @race=Race.find(params[:element_id])  
     @tiers=Tier.all
     @users=User.where(:admin => false).order('client_name ASC')
     @race.update_attributes(:status=>params[:update_value])
     render 'race_result',:layout=>false
  end
  
  def view_clients_balance
    @final=params[:id]
    @users=User.where(:admin => false).order('client_name ASC')
    render 'client_balances'
  end
  def contacts
    @users=User.where(:admin => false).order('client_name ASC')
  end
  def view_prev_races
    from=params[:from]
    to=params[:to]
  
    @races=Race.find(:all,:conditions =>["date BETWEEN ? AND ? ", Date.parse(from).strftime("%y/%m/%d"),Date.parse(to).strftime("%y/%m/%d")])
    
   render :partial=>'prev_races'
  end
  
  
end
