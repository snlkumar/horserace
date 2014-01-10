class AddColumnRespondToUser < ActiveRecord::Migration
  def change
    add_column :users, :respond_to, :string
     add_column :users, :password, :string
  end
end
