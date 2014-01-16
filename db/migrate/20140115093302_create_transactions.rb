class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :withdraw 
      t.float :deposit
      t.integer :owner
      t.float :balance_before
      t.float :balance_after
      t.references :user
      t.references :race
      t.references :bank_detail
      t.timestamps
    end
  end
end
