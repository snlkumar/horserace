class AddColumnsStatusDateTrialAccountToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :string,:default=>'active'
    add_column :users, :trading_start_date, :date
    add_column :users, :is_this_trial, :boolean
  end
end
