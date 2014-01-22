class ChangeStatusOfClient < ActiveRecord::Migration
  def change
     change_column :clients, :status, :default => 'Inactive'  
  end
end
