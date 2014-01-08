class BankDetail < ActiveRecord::Base
  attr_accessible :account, :account_name, :bank_name, :bsb
  belongs_to :user
end
