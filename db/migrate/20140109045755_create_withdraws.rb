class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.float :amount
      t.references :user
      t.references :bank_detail

      t.timestamps
    end
  end
end
