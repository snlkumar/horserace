class AddHorsePlaceToRace < ActiveRecord::Migration
  def change
    add_column :races, :horse_place,:string
  end
end
