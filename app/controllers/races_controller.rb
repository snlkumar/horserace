class RacesController < InheritedResources::Base
  before_filter :login_required
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
    @races=current_user.races.where('date >= ? AND date <= ?',Date.parse(from).strftime("%Y-%m-%d"),Date.parse(to).strftime("%Y-%m-%d"))
    # @races=Race.where('date >= ? AND date <= ?',Date.parse(from).strftime("%Y-%m-%d"),Date.parse(to).strftime("%Y-%m-%d"))
    
   render :partial=>'prev_races'
  end
  def past_races
    today= Date.today
    @races=Race.where('status=? OR status=?','win','lost')
  end
  
  def view_login
    @users=User.where(:admin=>false)
    render 'users/view_login'
  end
  def destroy
    super
    flash[:notice]="Succesfully deleted"
    redirect_to current_races_races_path
  end
    
  
  
end
