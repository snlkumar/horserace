class AddFeeToClient < ActiveRecord::Migration
  def change
    add_column :clients,:fee,:float  
    end
end
