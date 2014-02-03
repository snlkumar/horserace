class RacesController < InheritedResources::Base
  before_filter :login_required
  before_filter :admin_required ,:only=>[:new,:create,:change_status,:destroy]
  def show
    @race=Race.find(params[:id])
    @tiers=Tier.all
    @users=User.where(:admin => false).order('client_name ASC')    
  end
  
  def create
    @race = Race.new(params[:race])

    respond_to do |format|
      if @race.save
        format.html { redirect_to @race, notice: 'Race successfully created.' }
        format.json { render json: @race, status: :created, location: @race }
      else
        format.html { render action: "new" }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
  def current_races
     @races=Race.order('date ASC')
     @current_races=Race.where(:status=>nil).order('date ASC')
    
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
     @race.update_attributes(:status=>params[:update_value],:horse_place=>params[:original_value])
     render 'race_result',:layout=>false
  end
  
  def view_clients_balance
    @final=params[:id]
    @users=Client.where(:status => 'Active')
    render 'client_balances'
  end
  def contacts
    @users=User.where(:admin => false).order('client_name ASC')
  end
  def view_prev_races
    from=params[:from]
    to=params[:to]  
    @races=current_user.client.races.where('date >= ? AND date <= ?',Date.parse(from).strftime("%Y-%m-%d"),Date.parse(to).strftime("%Y-%m-%d"))
    # @races=Race.where('date >= ? AND date <= ?',Date.parse(from).strftime("%Y-%m-%d"),Date.parse(to).strftime("%Y-%m-%d"))
    
   render :partial=>'prev_races'
  end
  def past_races
    today= Date.today
    @races=Race.where('status=? OR status=?','win','lost')
  end
  
  def view_login
    @clients=Client.all
    render 'clients/view_login'
  end
  def destroy
    @race=Race.find params[:id]
   @ur= UsersRaces.where(:race_id=>@race.id)
   @ur.each do |ur|
     ur.delete
   end
    @race.delete   
    flash[:notice]="Succesfully deleted"
    redirect_to current_races_races_path
  end
  
  def protest
    @race=Race.find params[:id]
    @clients=@race.clients
    @clients.each do |client|
    userrace=UsersRaces.find_by_client_id_and_race_id(client.id,@race.id)
    @balance=client.balance
    if userrace.win
       @balance=@balance-userrace.win
       UsersRaces.update(userrace.id,:win=>nil)
    else      
       @balance=@balance+userrace.lost
       UsersRaces.update(userrace.id,:lost=>nil)
    end
    Race.update(@race.id,:status=>nil)
    Client.update(client.id,:balance=>@balance)  
      # (UserMailer.protest_mail(@race,client)).deliver  
    end
    redirect_to current_races_races_path
  end
  
 def update_horse_place
   @race=Race.find(params[:element_id])
   if @race.update_attributes(:horse_place=>params[:update_value])
   render :text=>"updating..."   
   end
 end 
    
  
  
end
