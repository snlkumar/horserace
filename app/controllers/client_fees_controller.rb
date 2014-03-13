class ClientFeesController < InheritedResources::Base
  
  def clients_fee  
    months=['','January','February','March','April','May','June','July','Augest','September','October','November','December']
    month=months[params[:month].to_i]
    unless current_user.client
    @month="Listing clients fee for the month #{month}"
    @clients_fee=[]
    clients_fee  =ClientFee.where(:month=>month)
      clients_fee.each do |cf| @clients_fee<< cf if cf.client.status=="Active" end
        render :partial=>'view_clients_fee'
      else
        @month="Fee for the month #{month}"
        @client_fee  =ClientFee.where(:month=>month,:client_id=>current_user.client.id)
        render :partial=>'view_client_fee'
      end
    
  end
end
