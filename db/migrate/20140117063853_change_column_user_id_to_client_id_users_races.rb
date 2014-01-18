class ChangeColumnUserIdToClientIdUsersRaces < ActiveRecord::Migration
  def change
    rename_column :users_races, :user_id, :client_id
    rename_column :transactions,:user_id, :client_id
    rename_column :bank_details,:user_id, :client_id
    
  end
end
