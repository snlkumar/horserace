class Tier < ActiveRecord::Base
  attr_accessible :name, :weight
  validates :name,:weight,:presence=>true,:uniqueness=>true
  has_many :users
  before_destroy :check_users
  
  
  
  
  def check_users
    unless self.users.count==0
      errors.add(:users, "Can't destroy tier")
      return false
    end
  end
end
