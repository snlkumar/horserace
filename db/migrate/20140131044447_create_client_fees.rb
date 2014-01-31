class CreateClientFees < ActiveRecord::Migration
  def change
    create_table :client_fees do |t|
      t.references :client
      t.float :old_balance
      t.float :new_balance
      t.float :profit
      t.float :fee
      t.string :month

      t.timestamps
    end
  end
end
