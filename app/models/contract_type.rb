class ContractType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  acts_as_list

  has_many :job_offers
end
