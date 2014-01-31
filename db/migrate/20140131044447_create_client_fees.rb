class CreateClientFees < ActiveRecord::Migration
  def change
    create_table :client_fees do |t|

      t.timestamps
    end
  end
end
