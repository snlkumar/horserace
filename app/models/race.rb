class Race < ActiveRecord::Base
  attr_accessible :name, :date,:time, :horse, :default_odd,:status
  validates :name,:horse,:default_odd,:presence=>true
  validates :default_odd,:presence=>true
end
