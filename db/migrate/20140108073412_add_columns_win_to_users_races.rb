class AddColumnsWinToUsersRaces < ActiveRecord::Migration
  def change    
     add_column :users_races, :win, :float
     add_column :users_races, :lost, :float
  end
end
