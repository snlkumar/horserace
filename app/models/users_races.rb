class UsersRaces < ActiveRecord::Base
  attr_accessible :user_id,:race_id,:processing_balance,:win,:lost,:bet_amount
  belongs_to :user
  belongs_to :race
  # attr_accessible :title, :body
end
