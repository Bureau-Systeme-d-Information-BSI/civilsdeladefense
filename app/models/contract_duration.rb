# frozen_string_literal: true

class ContractDuration < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers, dependent: :nullify
end

# == Schema Information
#
# Table name: contract_durations
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contract_durations_on_name      (name) UNIQUE
#  index_contract_durations_on_position  (position)
#
