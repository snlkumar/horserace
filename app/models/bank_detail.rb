class BankDetail < ActiveRecord::Base
  attr_accessible :account, :account_name, :bank_name, :bsb,:client_id
  belongs_to :client
  has_many :withdraws
  # validates_format_of :account_name, :with => /^[ a-zA-Z() ]+$/,:if=>:account_name_changed?
  # validates_format_of :bank_name, :with => /^[ a-zA-Z() ]+$/,:if=>:bank_name_changed?
  # validates :account_name,:presence=>true,:uniqueness=>true,:if=>:account_name_changed?
end
