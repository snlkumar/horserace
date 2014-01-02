class CreateUsersRaces < ActiveRecord::Migration
  def change
    create_table :users_races,:force => true do |t|
      t.references :user
      t.references :race
      t.float :processing_balance

      t.timestamps
    end
    add_index :users_races, [:user_id,:race_id]
     
  end
end
