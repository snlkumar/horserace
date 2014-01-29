class AddHorsePlaceToClients < ActiveRecord::Migration
  def change
    add_column :clients, :horse_place,:string
  end
end
