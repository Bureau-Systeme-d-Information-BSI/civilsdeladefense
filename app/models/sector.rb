# frozen_string_literal: true

# Genreric activity sector of a job offer. Technical, health, etc.
class Sector < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end
