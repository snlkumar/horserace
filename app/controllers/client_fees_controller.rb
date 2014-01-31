class ClientFeesController < InheritedResources::Base
  
  def clients_fee  
    @month="Listing clients fee for the month #{params[:month]}"
    @clients_fee  =ClientFee.where(:month=>params[:month])
    render :partial=>'view_clients_fee'
  end
end
