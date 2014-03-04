class AddBetAmountToClient < ActiveRecord::Migration
  def change
    add_column :clients,:bet_amount,:float
  end
end
