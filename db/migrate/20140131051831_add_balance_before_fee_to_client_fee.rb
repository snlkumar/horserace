class AddBalanceBeforeFeeToClientFee < ActiveRecord::Migration
  def change
    add_column :client_fees,:balance_before_fee,:float
  end
end
