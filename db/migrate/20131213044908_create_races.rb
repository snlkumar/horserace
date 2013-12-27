class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.date :date
      t.time :time
      t.string :horse
      t.string :status
      t.float :default_odd

      t.timestamps
    end
  end
end
