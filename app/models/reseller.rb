class Reseller < ActiveRecord::Base
  attr_accessible :address, :name,:user_attributes
  has_one :user
    accepts_nested_attributes_for :user
end
