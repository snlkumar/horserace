class AddColumnsClientNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_number, :string
    add_column :users, :address, :string
    add_column :users, :dob, :date
    add_column :users, :consultant_name, :string
    add_column :users, :consultant_contact_number, :string
  end
end
