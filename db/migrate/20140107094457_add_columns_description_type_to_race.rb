class AddColumnsDescriptionTypeToRace < ActiveRecord::Migration
  def change
    add_column :races, :description, :string
    add_column :races, :race_type, :string
  end
end
