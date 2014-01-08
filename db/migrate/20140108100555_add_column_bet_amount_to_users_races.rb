class AddColumnBetAmountToUsersRaces < ActiveRecord::Migration
  def change
    add_column :users_races, :bet_amount, :float
     add_column :races, :ticket_number, :string
  end
end
