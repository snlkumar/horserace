class ClientFeesController < InheritedResources::Base
  
  def clients_fee  
    months=['','January','February','March','April','May','June','July','Augest','September','October','November','December']
    month=months[params[:month].to_i]
    @month="Listing clients fee for the month #{month}"
    @clients_fee  =ClientFee.where(:month=>month)
    render :partial=>'view_clients_fee'
  end
end
