class ChangeStatusOfClient < ActiveRecord::Migration
  def change
  change_column_default(:clients,:status,"Inactive")
  end
end
