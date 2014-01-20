class BankDetail < ActiveRecord::Base
  attr_accessible :account, :account_name, :bank_name, :bsb,:client_id
  belongs_to :client
  has_many :withdraws
  validates_format_of :account_name,:bank_name, :with => /^[a-zA-Z() ]+$/
  validates :account_name,:presence=>true,:uniqueness=>true
end
