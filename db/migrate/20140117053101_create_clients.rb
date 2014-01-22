class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name
      t.float :balance
      t.references :tier
      t.references :reseller
      t.string :phone
      t.string :custom_password
      t.string :respond_via
      t.boolean :admin, :default=>false
      t.string :balance_after_bet
      t.string :status,:default=>'Inactive'
      t.string :trading_start_date
      t.boolean :is_this_trial
      t.integer :trail_duration
      t.string :client_number
      t.string :address
      t.string :consultant_contact_number
      t.string :consultant_name
      t.date :dob
      t.string :enquiry
      t.timestamps
    end
  end
end
