class ChangeColumnRespondToUser < ActiveRecord::Migration
  def change
    rename_column :users, :respond_to,:respond_via
     
  end
end
