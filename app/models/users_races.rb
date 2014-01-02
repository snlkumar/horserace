class UsersRaces < ActiveRecord::Base
  attr_accessible :user_id,:race_id,:processing_balance
  belongs_to :user
  belongs_to :race
  # attr_accessible :title, :body
end
