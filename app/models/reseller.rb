class Reseller < ActiveRecord::Base
  attr_accessible :address, :name,:user_attributes,:phone
  has_many :clients
  has_one :user
  accepts_nested_attributes_for :user
  before_destroy :check_clients
  after_destroy :delete_user
  
  def check_clients
    puts "i am in check client wwith #{self.clients.count}"
    if self.clients.count>0
      self.errors[:base] << "Reseller can not be delete while it's clients exist"
      return false
    end
  end
  def delete_user
   self.user.delete
  end
end
