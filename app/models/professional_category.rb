class ProfessionalCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :job_offers
  has_many :salary_ranges, dependent: :destroy
end
