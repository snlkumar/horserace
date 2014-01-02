class AddColumnBalanceAfterBetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :balance_after_bet, :string
  end
end
