class CreateBankDetails < ActiveRecord::Migration
  def change
    create_table :bank_details do |t|
      t.string :bsb
      t.string :account
      t.string :bank_name
      t.string :account_name
      t.references :user

      t.timestamps
    end
  end
end
