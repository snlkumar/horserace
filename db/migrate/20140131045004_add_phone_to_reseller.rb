class AddPhoneToReseller < ActiveRecord::Migration
  def change
    add_column :resellers,:phone,:string
  end
end
