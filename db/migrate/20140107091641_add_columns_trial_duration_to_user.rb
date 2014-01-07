class AddColumnsTrialDurationToUser < ActiveRecord::Migration
  def change
    add_column :users, :trail_duration, :integer
  end
end
