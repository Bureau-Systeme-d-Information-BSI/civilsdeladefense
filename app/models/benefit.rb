# frozen_string_literal: true

# Avantage en nature
class Benefit < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :benefit_job_offers
  has_many :job_offers, through: :benefit_job_offers
end

# == Schema Information
#
# Table name: benefits
#
#  id         :uuid             not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_benefits_on_position  (position)
#
