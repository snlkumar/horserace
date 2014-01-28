class ChangeBalanceAfterBetToInitialBalance < ActiveRecord::Migration
 def change
    add_column :clients, :initial_balance, :float
  end
end
