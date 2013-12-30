class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :name
      t.float :weight

      t.timestamps
    end
    Tier.create :name => "T1", :weight => 10
    Tier.create :name => "T2", :weight => 20
    Tier.create :name => "T3", :weight => 50
    Tier.create :name => "T4", :weight => 100
  end
end
