class ResellersController < InheritedResources::Base
  before_filter :login_required
  before_filter :admin_required,except: :view_clients_login_history
  def new
     @reseller = Reseller.new
     @reseller.build_user
  end
  
  def create
    @reseller=Reseller.new(params[:reseller])
    if @reseller.save
     redirect_to resellers_path
    else
      render 'new'
    end    
  end
  
  def show
    @reseller=Reseller.find(params[:id])
    @clients=@reseller.clients
  end
  def view_clients_login_history
    @clients=current_user.reseller.clients
  end
  def update
    @reseller=Reseller.find params[:id]
    @reseller.update_attributes(params[:reseller])
    flash[:notice]="Reseller updated successfully"
    redirect_to resellers_path
  end
end
