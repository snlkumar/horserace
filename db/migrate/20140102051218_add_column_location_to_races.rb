class AddColumnLocationToRaces < ActiveRecord::Migration
  def change
    add_column :races, :location, :string
  end
end
