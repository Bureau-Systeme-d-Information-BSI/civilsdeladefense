class ContractType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
