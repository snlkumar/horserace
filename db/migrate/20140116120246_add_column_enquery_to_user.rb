class AddColumnEnqueryToUser < ActiveRecord::Migration
  def change
    add_column :users, :enquiry, :string 
  end
end
