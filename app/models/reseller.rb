class Reseller < ActiveRecord::Base
  attr_accessible :address, :name,:user_attributes
  has_many :clients
  has_one :user
    accepts_nested_attributes_for :user
end
