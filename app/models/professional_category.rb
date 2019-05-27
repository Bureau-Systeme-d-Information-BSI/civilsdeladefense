# frozen_string_literal: true

# Socio-Professional category of a job offer
class ProfessionalCategory < ApplicationRecord
  acts_as_list
  default_scope -> { order(position: :asc) }

  validates :name, presence: true, uniqueness: true

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end
