# frozen_string_literal: true

# Legal type of job contract
class ContractType < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers, dependent: :nullify
end

# == Schema Information
#
# Table name: contract_types
#
#  id         :uuid             not null, primary key
#  duration   :boolean          default(FALSE)
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contract_types_on_name      (name) UNIQUE
#  index_contract_types_on_position  (position)
#
