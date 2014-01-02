class Race < ActiveRecord::Base
  attr_accessible :name, :date,:time, :horse, :default_odd,:status,:location,:users
  validates :name,:horse,:default_odd,:presence=>true
  validates :default_odd,:presence=>true
  after_create :update_balance
  has_and_belongs_to_many :users,:join_table => :users_races
  
  def update_balance 
    @users=User.where(:admin=>false) 
    @users.each do |user|      
    UsersRaces.create(:race_id=>self.id,:user_id=>user.id,:processing_balance=>user.balance)
    User.update(user.id,:balance=>user.calculated_balance_after_bet(self))
   end
  end
  
end
