class BankDetail < ActiveRecord::Base
  attr_accessible :account, :account_name, :bank_name, :bsb,:user_id
  belongs_to :user
  has_many :withdraws
  validates :bank_name,:presence=>true,:uniqueness=>true
end
