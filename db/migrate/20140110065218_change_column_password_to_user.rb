class ChangeColumnPasswordToUser < ActiveRecord::Migration
  def change
    rename_column :users, :password,:custom_password
     
  end
end
