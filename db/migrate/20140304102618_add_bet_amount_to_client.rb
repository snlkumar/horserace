class AddBetAmountToClient < ActiveRecord::Migration
  def change
    add_column :clients,:bet,:float
  end
end
