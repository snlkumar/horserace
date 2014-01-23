class AddColumnRaceStatusToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :race_status, :string
  end
end
